from shop.extensions import db
from sqlalchemy import func
from shop.models import Rating, Discount, ProductDiscount,ProductImage,Product
from datetime import datetime
from shop.models import *
from werkzeug.security import generate_password_hash, check_password_hash

def star_rating(value, count=None):
    if value is None:
        stars_html = '<span class="rating-stars">☆☆☆☆☆</span>'
    else:
        full_stars = int(value)
        half_star = value % 1 >= 0.5
        empty_stars = 5 - full_stars - (1 if half_star else 0)
        stars_html = '<span class="rating-stars">'
        stars_html += '<i class="fas fa-star"></i> ' * full_stars
        stars_html += '<i class="fas fa-star-half-alt"></i> ' if half_star else ''
        stars_html += '<i class="far fa-star"></i> ' * empty_stars
        stars_html += '</span>'

    if count is not None:
        stars_html += f" ({count} đánh giá)"

    return stars_html

def set_password(password, method='pbkdf2:sha256'):
    return generate_password_hash(password, method=method)
def check_password(hash_password,password):
    return check_password_hash(password, password)
def get_cheapest_products():
    now = datetime.utcnow()
    products = db.session.query(
        Product,
        func.coalesce(
            func.min(Product.price - (Product.price * Discount.discount_amount / 100)),
            Product.price
        ).label('final_price')
    ).outerjoin(ProductDiscount, Product.id == ProductDiscount.product_id
    ).outerjoin(Discount, (ProductDiscount.discount_id == Discount.id) & (Discount.valid_from <= now) & (Discount.valid_to >= now)
    ).group_by(Product.id).order_by('final_price').limit(5).all()

    # Giữ nguyên đối tượng Product và bỏ qua phần tính giá
    products = [product for product, final_price in products]
    return products

def get_valid_discount_amount(product_id):
    now = datetime.utcnow()
    valid_discount = Discount.query.join(
        ProductDiscount, Discount.id == ProductDiscount.discount_id
    ).filter(
        ProductDiscount.product_id == product_id,
        Discount.valid_from <= now,
        Discount.valid_to >= now
    ).order_by(Discount.discount_amount.desc()).first()

    if valid_discount:
        return valid_discount.discount_amount
    return 0

def get_product_data(products):
    product_data = []
    for product in products:
        avg_rating = db.session.query(func.avg(Rating.score)).filter(Rating.product_id == product.id).scalar()
        review_count = db.session.query(func.count(Rating.score)).filter(Rating.product_id == product.id).scalar()
        discount_amount = get_valid_discount_amount(product.id)
        product_data.append({
            'product': product,
            'avg_rating': avg_rating,
            'review_count': review_count,
            'discount_amount': discount_amount,
        })
    return product_data
def get_products_by_category(category, price_range=None, discount_range=None):
    now = datetime.utcnow()
    avg_price = db.session.query(func.avg(Product.price)).scalar()
    
    # Khởi tạo truy vấn cơ bản
    query = Product.query

    if category == 'noibat':
        query = query.join(ProductDiscount).join(Discount).filter(
            Discount.discount_amount >= 30,
            Discount.valid_from <= now,
            Discount.valid_to >= now
        )
    if category == 'moi':
        query = query.filter_by(is_new=True)
   
    if category in ['5stars', '4stars', '3stars']:
        stars = int(category[0])
        query = query.join(Rating).group_by(Product.id).having(
            func.avg(Rating.score) == stars
        )

    if price_range:
        min_price, max_price = map(int, price_range.split('-'))
        query = query.filter(Product.price.between(min_price, max_price))

    if discount_range:
        min_discount, max_discount = map(int, discount_range.split('-'))
        query = query.join(ProductDiscount).join(Discount)
        query = query.filter(
            Discount.discount_amount.between(min_discount, max_discount),
            Discount.valid_from <= now,
            Discount.valid_to >= now
        )

    products = query.all()
    return products
def get_home_page_data():
    new_products = Product.query.filter_by(is_new=True).all()
    avg_price = db.session.query(func.avg(Product.price)).scalar()
    discount_products = db.session.query(Product).join(ProductDiscount).join(Discount).filter(
        Product.price > avg_price,
        Discount.discount_amount > 20
    ).all()
    
    now = datetime.utcnow()
    big_discount_products = db.session.query(Product).join(ProductDiscount).join(Discount).filter(
        Discount.discount_amount >= 20,
        Discount.valid_from <= now,
        Discount.valid_to >= now
    ).all()
    cheaps_products = get_cheapest_products()

    data = {
        'new_products': get_product_data(new_products),
        'discounted_products': get_product_data(discount_products),
        'big_discount_products': get_product_data(big_discount_products),
        'cheaps_products': get_product_data(cheaps_products)
    }
    return data
def get_product_details(product_id):
    product = Product.query.get_or_404(product_id)
    images = ProductImage.query.filter_by(product_id=product.id).all()
    discount_amount = get_valid_discount_amount(product_id)
    discounted_price = product.price - (discount_amount * product.price / 100)
    ratings = Rating.query.filter_by(product_id=product.id).all()
    avg_rating = db.session.query(func.avg(Rating.score)).filter(Rating.product_id == product.id).scalar()
    review_count = len(ratings)
    recommended_products = Product.query.order_by(func.random()).limit(5).all()
    recommended_product_data = get_product_data(recommended_products)

    product_detail = {
        'product': product,
        'images': images,
        'discount_amount': discount_amount,
        'discounted_price': discounted_price,
        'avg_rating': avg_rating,
        'review_count': review_count,
        'recommended_product_data': recommended_product_data
    }
    return product_detail
def calculate_total_purchases(user_id):
    """
    Calculate the total amount of money a user has spent on purchases.
    """
    total = db.session.query(func.sum(Order.total)).filter(Order.user_id == user_id).scalar()
    return total if total is not None else 0

def count_user_products(user_id):
    """
    Count the total number of products a user has purchased.
    """
    # This will count the total number of items from order details for the user
    product_count = db.session.query(func.sum(OrderDetail.quantity)).join(Order).filter(Order.user_id == user_id).scalar()
    return product_count if product_count is not None else 0
