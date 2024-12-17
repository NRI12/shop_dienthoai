from datetime import timedelta
from functools import wraps
import os
from flask import Flask, abort, after_this_request, flash, jsonify, redirect, render_template, request, session, url_for
from shop.extensions import db, migrate
from sqlalchemy import func
from shop.forms import LoginForm, RegistrationForm, ProductForm, OrderForm, PaymentForm
from shop.utils import *
from flask_login import LoginManager, login_user, logout_user, login_required, current_user
from werkzeug.security import check_password_hash
from werkzeug.security import generate_password_hash
import logging
from werkzeug.utils import secure_filename
from pycaret.classification import load_model, predict_model
import pandas as pd
from sqlalchemy.orm import joinedload

logging.basicConfig(level=logging.DEBUG, filename='app.log', filemode='a',
                format='%(name)s - %(levelname)s - %(message)s')


model_path = os.path.join(os.path.dirname(__file__), 'model', 'tuned_model_new')
model = load_model(model_path)

app = Flask(__name__)
app.jinja_env.filters['star_rating'] = star_rating
app.config['SECRET_KEY'] = 'your_secret_key_here'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:password@database-2.czia64cy4ba2.us-east-1.rds.amazonaws.com:3306/new_database'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False


db.init_app(app)
migrate.init_app(app, db)

login_manage = LoginManager()
login_manage.init_app(app)
login_manage.login_view = "login"

UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif'}
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS


@property
def is_active(self):
    # Assuming you might have an 'active' column that stores the status
    return True  # Or return self.active if you have such a column
def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if not current_user.is_authenticated or not current_user.is_admin():
            abort(403)
        return f(*args, **kwargs)
    return decorated_function

@login_manage.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

with app.app_context():
    from shop.models import Product

@app.template_filter()
def format_currency(value):
    try:
        value = int(value)
        return f"{value:,}".replace(",", ".")
    except ValueError:
        return value
@app.route("/home")

def home():
    companies = [
        "Apple.jpg", "Samsung.jpg", "Oppo.jpg", "Nokia.jpg", "Huawei.jpg", "Xiaomi.png",
        "Realme.png", "Vivo.jpg", "Philips.jpg", "Mobell.jpg", "Mobiistar.jpg", "Itel.jpg",
        "Coolpad.png", "HTC.jpg", "Motorola.jpg"
    ]
    data = get_home_page_data()
    return render_template("index.html", **data,companies=companies)
@app.route('/api/check_user_info', methods=['GET'])
def check_user_info():
    if not current_user.is_authenticated:
        return jsonify(success=False, message="Bạn cần đăng nhập trước khi thanh toán.")

    if not current_user.address or not current_user.phone_number:
        return jsonify(success=False, message="Vui lòng cập nhật địa chỉ và số điện thoại trong hồ sơ của bạn trước khi thanh toán.")

    return jsonify(success=True)


@app.route('/user_profile')
@login_required
def user_profile():
    user_id = current_user.id
    user = User.query.get(user_id)
    orders = Order.query.filter_by(user_id=user_id).all()
    for order in orders:
        order.order_details = OrderDetail.query.filter_by(order_id=order.id).all()
        for detail in order.order_details:
            detail.product = Product.query.get(detail.product_id)
    return render_template('nguoidung.html', user=user, orders=orders)
@app.route('/giohang')
@login_required
def giohang():
    return render_template('giohang.html')
@app.route('/update_user_info', methods=['POST'])
@login_required
def update_user_info():
    user = current_user
    data = request.get_json()
    print(data)
    try:
        user.full_name = data['fullName']
        user.email = data['email']
        user.phone_number = data['phoneNumber']
        user.address = data['address']  # Thêm dòng này
        db.session.commit()
        return jsonify({'success': True, 'message': 'Thông tin đã được cập nhật thành công!'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'Lỗi khi cập nhật thông tin: ' + str(e)})
@app.route('/logout')
def logout():
    logout_user()
    return redirect(url_for('home'))          
@app.route('/product/<int:product_id>')
def product_detail(product_id):
    product_details = get_product_details(product_id)
    reviews = Rating.query.filter_by(product_id=product_id).join(User, Rating.user_id == User.id).all()
    return render_template('chitietsanpham.html', **product_details, reviews=reviews)

@app.route('/shop')
def shop():
    category = request.args.get('category')
    price_range = request.args.get('price_range')
    discount_range = request.args.get('discount_range')

    products = get_products_by_category(category, price_range, discount_range)
    product_data = get_product_data(products)
    return render_template('shop.html', products=product_data, category=category, price_range=price_range, discount_range=discount_range)
@app.route('/cancel_order/<int:order_id>', methods=['POST'])
@login_required
def cancel_order(order_id):
    order = Order.query.get(order_id)
    if not order:
        return jsonify({'success': False, 'message': 'Đơn hàng không tồn tại.'})

    if order.user_id != current_user.id:
        return jsonify({'success': False, 'message': 'Bạn không có quyền hủy đơn hàng này.'})

    if order.status != 'processing':
        return jsonify({'success': False, 'message': 'Chỉ có thể hủy đơn hàng đang xử lý.'})

    # Cập nhật trạng thái đơn hàng
    order.status = 'cancelled'

    # Xử lý hoàn tiền nếu có
    payments = Payment.query.filter_by(order_id=order.id).all()
    for payment in payments:
        refund = Payment(
            order_id=order.id,
            amount=-payment.amount,  # Số tiền âm để chỉ ra hoàn tiền
            payment_date=datetime.utcnow(),
            payment_method=payment.payment_method
        )
        db.session.add(refund)

    # Cập nhật số lượng sản phẩm
    for detail in order.order_details:
        product = Product.query.get(detail.product_id)
        if product:
            product.stock += detail.quantity

    db.session.commit()
    return jsonify({'success': True, 'message': 'Đơn hàng đã được hủy và tiền đã được hoàn.'})

@app.route('/api/checkout', methods=['POST'])
def checkout():
    try:
        data = request.get_json()
        print("Received data:", data)
        print("Checking user details: ", current_user.address, current_user.phone_number)

        if not current_user.address or not current_user.phone_number:
            return jsonify(success=False, message="Vui lòng cập nhật địa chỉ và số điện thoại trong hồ sơ của bạn trước khi thanh toán.")
        
        full_name = data['fullName']
        email = data['email']
        address = data['address']
        phone_number = data['phoneNumber']
        payment_method = data['paymentMethod']
        cart = data['cart']

        order = Order(
            user_id=current_user.id,
            order_date=datetime.utcnow(),
            total=sum(item['price'] * item['quantity'] for item in cart.values()),
            status='processing',
            address=address
        )
        db.session.add(order)
        db.session.commit()

        for item in cart.values():
            order_detail = OrderDetail(
                order_id=order.id,
                product_id=item['id'],
                quantity=item['quantity'],
                price=item['price']
            )
            db.session.add(order_detail)

        payment = Payment(
            order_id=order.id,
            amount=order.total,
            payment_date=datetime.utcnow(),
            payment_method=payment_method
        )
        db.session.add(payment)
        db.session.commit()

        return jsonify(success=True)

    except Exception as e:
        print(f"Error processing checkout: {e}")
        return jsonify(success=False, message=str(e))
@app.route('/api/submit_review', methods=['POST'])
@login_required
def submit_review():
    try:
        data = request.get_json()
        new_rating = int(data['rating'])
        new_comment = data['comment']
        product_id = int(data['product_id'])

        if not (1 <= new_rating <= 5):
            return jsonify({'success': False, 'message': 'Invalid rating. Please choose between 1 and 5.'})

        # Kiểm tra xem người dùng đã có đánh giá cho sản phẩm này chưa
        existing_review = Rating.query.filter_by(user_id=current_user.id, product_id=product_id).first()

        if existing_review:
            # Cập nhật đánh giá hiện tại
            existing_review.score = new_rating
            existing_review.comment = new_comment
            existing_review.rating_date = datetime.utcnow()
            db.session.commit()
            return jsonify({'success': True, 'message': 'Your review has been updated successfully.'})
        else:
            # Tạo đánh giá mới
            new_review = Rating(
                user_id=current_user.id,
                product_id=product_id,
                score=new_rating,
                comment=new_comment,
                rating_date=datetime.utcnow()
            )
            db.session.add(new_review)
            db.session.commit()
            return jsonify({'success': True, 'message': 'Your review has been submitted successfully.'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'success': False, 'message': 'An error occurred: ' + str(e)})
@app.route('/admin')
@admin_required
def admin():
    return render_template('admin.html')
@app.route('/api/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    return jsonify([{
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stock': product.stock,
        'promotion_text': product.promotion_text,
    } for product in products])

@app.route('/api/products/<int:id>', methods=['GET'])
def get_product(id):
    product = Product.query.get_or_404(id)
    return jsonify({
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stock': product.stock,
        'promotion_text': product.promotion_text,
        'screen': product.screen,
        'cpu': product.cpu,
        'ram': product.ram,
        'storage': product.storage,
        'camera': product.camera,
        'os': product.os,
        'features': product.features,
        'battery': product.battery
    })
@app.route('/api/products/<int:id>', methods=['PUT'])
def update_product(id):
    product = Product.query.get_or_404(id)
    data = request.form
    files = request.files.getlist('images')

    product.name = data['name']
    product.description = data['description']
    product.price = data['price']
    product.stock = data['stock']
    product.promotion_text = data['promotion_text']
    product.screen = data['screen']
    product.cpu = data['cpu']
    product.ram = data['ram']
    product.storage = data['storage']
    product.camera = data['camera']
    product.os = data['os']
    product.features = data['features']
    product.battery = data['battery']
    
    # Xóa hình ảnh cũ nếu có hình ảnh mới
    if files:
        old_images = ProductImage.query.filter_by(product_id=product.id).all()
        for image in old_images:
            os.remove(os.path.join(app.config['UPLOAD_FOLDER'], image.url))
            db.session.delete(image)
        
        for file in files:
            if file:
                filename = secure_filename(file.filename)
                filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(filepath)
                product_image = ProductImage(product_id=product.id, url=filename)
                db.session.add(product_image)

    db.session.commit()
    return jsonify({'message': 'Product updated successfully'}), 200
@app.route('/login', methods=['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
    user = User.query.filter_by(username=username).first()
    if user:
        if user.locked:
            return jsonify(success=False, message="Tài khoản của bạn đã bị khóa."), 403
        if check_password_hash(user.password, password):
            login_user(user)
            return jsonify(success=True, is_admin=user.is_admin()), 200

    return jsonify(success=False, message="Sai tài khoản hoặc mật khẩu"), 400
@app.before_request
def check_if_user_locked():
    if current_user.is_authenticated and current_user.locked:
        logout_user()
        flash('Tài khoản của bạn đã bị khóa.', 'warning')
        return redirect(url_for('login'))

@app.route('/register', methods=['POST'])
def register():
    username = request.form['username']
    email = request.form['email']
    fullname = request.form['fullname']
    password = request.form['password']
    user = User.query.filter_by(username=username).first()
    if user:
        return jsonify(success=False, message="Tài khoản đã tồn tại!")
    hashed_password = generate_password_hash(password, method='pbkdf2:sha256')
    new_user = User(username=username, password=hashed_password, email=email, full_name=fullname)
    db.session.add(new_user)
    db.session.commit()
    return jsonify(success=True)
@app.route('/api/products', methods=['POST'])
def add_product():
    data = request.form
    files = request.files.getlist('images')

    product = Product(
        name=data['name'],
        description=data['description'],
        price=data['price'],
        stock=data['stock'],
        promotion_text=data['promotion_text'],
        screen=data['screen'],
        cpu=data['cpu'],
        ram=data['ram'],
        storage=data['storage'],
        camera=data['camera'],
        os=data['os'],
        features=data['features'],
        battery=data['battery']
    )
    db.session.add(product)
    db.session.commit()

    for file in files:
        if file:
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            product_image = ProductImage(product_id=product.id, url=filename)
            db.session.add(product_image)

    db.session.commit()
    return jsonify({'message': 'Product added successfully'}), 201

@app.route('/api/products/<int:id>', methods=['DELETE'])
def delete_product(id):
    product = Product.query.get_or_404(id)
    try:
        OrderDetail.query.filter_by(product_id=product.id).delete()
        Rating.query.filter_by(product_id=product.id).delete()
        ProductDiscount.query.filter_by(product_id=product.id).delete()
        db.session.delete(product)
        db.session.commit()
        return jsonify({'message': 'Product deleted successfully'})
    except Exception as e:
        db.session.rollback()
        return jsonify({'error': str(e)}), 500
@app.route('/api/orders', methods=['GET'])
def get_orders():
    orders = Order.query.all()
    return jsonify([{
        'id': order.id,
        'user_id': order.user_id,
        'total': order.total,
        'status': order.status,
        'order_date': order.order_date.strftime("%Y-%m-%d %H:%M:%S"),
        'address': order.address,
    } for order in orders])

@app.route('/api/orders/<int:id>', methods=['GET'])
def get_order(id):
    order = Order.query.get_or_404(id)
    order_details = OrderDetail.query.filter_by(order_id=id).all()
    details = [{
        'product_id': detail.product_id,
        'quantity': detail.quantity,
        'price': detail.price,
        'discount': detail.discount
    } for detail in order_details]
    return jsonify({
        'id': order.id,
        'user_id': order.user_id,
        'total': order.total,
        'status': order.status,
        'order_date': order.order_date.strftime("%Y-%m-%d %H:%M:%S"),
        'address': order.address,
        'details': details
    })
@app.route('/api/orders/<int:id>', methods=['PUT'])
def update_order(id):
    order = Order.query.get_or_404(id)
    data = request.json
    order.status = data['status']
    order.address = data['address']
    db.session.commit()
    return jsonify({'message': 'Order updated successfully'})
@app.route('/api/orders/<int:id>', methods=['DELETE'])
def delete_order(id):
    order = Order.query.get_or_404(id)
    db.session.delete(order)
    db.session.commit()
    return jsonify({'message': 'Order deleted successfully'})


@app.route('/api/customers', methods=['GET'])
def get_customers():
    customers = User.query.filter_by(role='customer').all()
    customer_list = []
    for customer in customers:
        order_count = Order.query.filter_by(user_id=customer.id).count()
        total_spent = db.session.query(db.func.sum(Order.total)).filter_by(user_id=customer.id).scalar() or 0
        customer_list.append({
            'id': customer.id,
            'username': customer.username,
            'email': customer.email,
            'full_name': customer.full_name,
            'birth_date': customer.birth_date.strftime('%Y-%m-%d') if customer.birth_date else None,
            'address': customer.address,
            'phone_number': customer.phone_number,
            'order_count': order_count,
            'total_spent': float(total_spent)
        })
    return jsonify(customer_list)

@app.route('/api/customers', methods=['POST'])
def add_customer():
    data = request.json
    new_customer = User(
        username=data['username'],
        email=data['email'],
        password=data['password'],
        full_name=data['full_name'],
        birth_date=data['birth_date'],
        address=data['address'],
        phone_number=data['phone_number'],
        role='customer'
    )
    db.session.add(new_customer)
    db.session.commit()
    return jsonify({'message': 'Customer added successfully'})

@app.route('/api/customers/<int:id>', methods=['GET'])
def get_customer(id):
    customer = User.query.get_or_404(id)
    
    # Tính số lượng đơn hàng
    order_count = Order.query.filter_by(user_id=customer.id).count()

    # Tính tổng chi tiêu từ các đơn hàng đã thanh toán
    total_spent = db.session.query(
        db.func.sum(Payment.amount)
    ).join(Order, Order.id == Payment.order_id).filter(
        Order.user_id == customer.id,
        Order.status == 'shipped'  # Giả sử chỉ tính các đơn đã giao
    ).scalar() or 0

    return jsonify({
        'id': customer.id,
        'username': customer.username,
        'email': customer.email,
        'full_name': customer.full_name,
        'birth_date': customer.birth_date.strftime('%Y-%m-%d') if customer.birth_date else None,
        'address': customer.address,
        'phone_number': customer.phone_number,
        'order_count': order_count,
        'total_spent': total_spent
    })


@app.route('/api/customers/<int:id>', methods=['PUT'])
def update_customer(id):
    customer = User.query.get_or_404(id)
    data = request.json
    customer.username = data['username']
    customer.email = data['email']
    customer.full_name = data['full_name']
    customer.birth_date = data['birth_date']
    customer.address = data['address']
    customer.phone_number = data['phone_number']
    db.session.commit()
    return jsonify({'message': 'Customer updated successfully'})

@app.route('/api/customers/<int:id>', methods=['DELETE'])
def delete_customer(id):
    customer = User.query.get_or_404(id)
    db.session.delete(customer)
    db.session.commit()
    return jsonify({'message': 'Customer deleted successfully'})


@admin_required
@app.route('/api/dashboard', methods=['GET'])
def get_dashboard_data():
    today = datetime.now()
    start_of_today = today.replace(hour=0, minute=0, second=0, microsecond=0)
    five_days_ago = today - timedelta(days=5)

    # Số đơn đặt hàng mới hôm nay
    new_orders_count_today = Order.query.filter(Order.order_date >= start_of_today).count()
    
    # Dữ liệu doanh thu cho 5 ngày qua
    sales_data = db.session.query(
        db.func.date(Order.order_date).label('date'),
        db.func.sum(Payment.amount).label('sales')
    ).select_from(Order).join(Payment).filter(
        Order.order_date >= five_days_ago,
        Order.status == 'shipped'  # Chỉ tính những đơn hàng đã được giao
    ).group_by(db.func.date(Order.order_date)).all()

    sales_data = [{'date': sale.date.strftime('%Y-%m-%d'), 'sales': float(sale.sales)} for sale in sales_data]

    total_sales_value = sum(sale['sales'] for sale in sales_data)

    user_registrations_count = User.query.filter_by(role='customer').count()

    # Tổng số lượng sản phẩm còn tồn kho
    total_stock = db.session.query(
        db.func.sum(Product.stock)
    ).filter(Product.stock > 0).scalar() or 0

    # Số đơn đặt hàng theo ngày trong 5 ngày qua
    order_data = db.session.query(
        db.func.date(Order.order_date).label('date'),
        db.func.count(Order.id).label('count')
    ).filter(Order.order_date >= five_days_ago).group_by(db.func.date(Order.order_date)).all()

    order_data = [{'date': order.date.strftime('%Y-%m-%d'), 'count': order.count} for order in order_data]

    # Top người dùng có tổng số đơn hàng lớn nhất
    top_users = db.session.query(
        User.username,
        db.func.count(Order.id).label('order_count'),
        db.func.sum(Payment.amount).label('total_spent')
    ).select_from(Order).join(Payment).join(User).filter(
        Order.status == 'shipped'
    ).group_by(User.id).order_by(db.func.sum(Payment.amount).desc()).limit(5).all()

    top_users_data = [{'username': user.username, 'order_count': user.order_count, 'total_spent': float(user.total_spent)} for user in top_users]

    # Thị phần thương hiệu
    brand_share_data = db.session.query(
        Brand.name,
        db.func.count(Product.id).label('product_count')
    ).join(Product).group_by(Brand.id).all()

    brand_share = [{'brand': brand.name, 'product_count': brand.product_count} for brand in brand_share_data]

    return jsonify({
        'new_orders_count_today': new_orders_count_today,
        'user_registrations_count': user_registrations_count,
        'total_sales_value': total_sales_value,
        'sales_data': sales_data,
        'order_data': order_data,
        'top_users': top_users_data,
        'brand_share': brand_share,  # Trả về dữ liệu cho biểu đồ tròn
        'total_stock': total_stock  # Tổng số lượng sản phẩm còn tồn kho
    })
@admin_required
@app.route('/api/get_reviews', methods=['GET'])
def get_reviews():
    page = request.args.get('page', default=1, type=int)
    per_page = 10
    reviews_pagination = Rating.query.paginate(page=page, per_page=per_page, error_out=False)

    reviews_data = pd.DataFrame([{'Review': review.comment, 'User': review.user.username} for review in reviews_pagination.items])

    predictions = predict_model(model, data=reviews_data)
    predicted_reviews = predictions[['Review', 'User', 'prediction_label', 'prediction_score']].to_dict(orient='records')
    
    # Wrap in a structure that includes a 'reviews' key
    response = {
        'reviews': predicted_reviews,
        'has_more': reviews_pagination.has_next  # This can be used to manage pagination controls
    }
    
    return jsonify(response)
from sqlalchemy.orm import joinedload

@app.route('/api/negative_reviews_summary', methods=['GET'])
def negative_reviews_summary():
    # Fetch all ratings with related product data
    ratings = Rating.query.options(joinedload(Rating.product)).all()
    
    # Convert reviews into DataFrame for prediction
    reviews_data = pd.DataFrame([{
        'Review': rating.comment,
        'ProductID': rating.product_id,
        'ProductName': rating.product.name  # Accessing the related product's name directly
    } for rating in ratings])

    # Predict sentiments
    predictions = predict_model(model, data=reviews_data)
    predictions['IsNegative'] = predictions['prediction_label'].apply(lambda x: 1 if x == 1 else 0)

    # Calculate negative review ratios
    summary = predictions.groupby(['ProductID', 'ProductName']).agg(
        TotalReviews=('ProductName', 'size'),
        NegativeReviews=('IsNegative', 'sum')
    ).reset_index()

    summary['NegativeReviewRatio'] = (summary['NegativeReviews'] / summary['TotalReviews']) * 100  # Multiply by 100 for percentage

    # Sort by highest ratio of negative reviews and return top 5
    top_negative = summary.sort_values(by='NegativeReviewRatio', ascending=False).head(5)

    # Convert to a JSON-friendly format
    top_negative_summary = [{
        'ProductID': row['ProductID'],  # Include ProductID here
        'ProductName': row['ProductName'],
        'TotalReviews': row['TotalReviews'],
        'NegativeReviews': row['NegativeReviews'],
        'NegativeReviewRatio': f"{row['NegativeReviewRatio']:.2f}"
    } for index, row in top_negative.iterrows()]

    print(top_negative_summary)    
    return jsonify(top_negative_summary)
@app.route('/api/negative_review_users', methods=['GET'])
def negative_review_users():
    # Fetch all ratings with related user data
    ratings = Rating.query.join(User).options(joinedload(Rating.user)).all()
    
    # Convert reviews into DataFrame for prediction
    reviews_data = pd.DataFrame([{
        'Review': rating.comment,
        'UserID': rating.user_id,
        'UserName': rating.user.username  # Accessing the related user's name directly
    } for rating in ratings])

    # Predict sentiments
    predictions = predict_model(model, data=reviews_data)
    predictions['IsNegative'] = predictions['prediction_label'].apply(lambda x: 1 if x == 1 else 0)

    # Filter predictions with prediction_score >= 0.80
    predictions = predictions[predictions['prediction_score'] >= 0.80]

    # Calculate negative review ratios
    user_summary = predictions.groupby(['UserID', 'UserName']).agg(
        TotalComments=('UserName', 'size'),
        NegativeComments=('IsNegative', 'sum')
    ).reset_index()

    user_summary['NegativeCommentRatio'] = (user_summary['NegativeComments'] / user_summary['TotalComments']) * 100

    # Sort by highest ratio of negative comments and return top 5
    top_negative_users = user_summary.sort_values(by='NegativeCommentRatio', ascending=False).head(5)

    # Convert to a JSON-friendly format
    top_negative_users_summary = [{
        'UserID': row['UserID'],
        'UserName': row['UserName'],
        'TotalComments': row['TotalComments'],
        'NegativeComments': row['NegativeComments'],
        'NegativeCommentRatio': f"{row['NegativeCommentRatio']:.2f}"
    } for index, row in top_negative_users.iterrows()]

    print(top_negative_users_summary)    
    return jsonify(top_negative_users_summary)

@app.route('/api/lock_user/<int:user_id>', methods=['POST'])
def lock_user(user_id):
    user = User.query.get(user_id)
    if user:
        if user.locked:
            user.locked = False
            db.session.commit()
            return jsonify({'message': 'User unlocked successfully'}), 200
        else:
            user.locked = True
            db.session.commit()
            return jsonify({'message': 'User locked successfully'}), 200
    else:
        return jsonify({'error': 'User not found'}), 404

if __name__ == "__main__":
    app.run(debug=True, port=4444)
