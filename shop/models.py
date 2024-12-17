from flask_login import UserMixin
from shop.app import db
from datetime import datetime

class User(db.Model,UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    email = db.Column(db.String(255), unique=True, nullable=False)
    full_name = db.Column(db.String(255), nullable=False)
    birth_date = db.Column(db.Date)
    address = db.Column(db.String(255))
    phone_number = db.Column(db.String(15))
    locked = db.Column(db.Boolean, default=False)  # Thêm cột locked
    role = db.Column(db.Enum('customer', 'admin', name='user_roles'), default='customer', nullable=False)
    orders = db.relationship('Order', backref='user', lazy=True)
    def is_admin(self):
        return self.role == 'admin'
class Category(db.Model):
    __tablename__ = 'categories'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    products = db.relationship('Product', backref='category', lazy=True)

class Product(db.Model):
    __tablename__ = 'products'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    stock = db.Column(db.Integer, nullable=False)
    category_id = db.Column(db.Integer, db.ForeignKey('categories.id'))
    brand_id = db.Column(db.Integer, db.ForeignKey('brands.id'))  # Thêm dòng này
    screen = db.Column(db.String(255))
    cpu = db.Column(db.String(255))
    ram = db.Column(db.String(255))
    storage = db.Column(db.String(255))
    camera = db.Column(db.String(255))
    os = db.Column(db.String(255))
    features = db.Column(db.Text)
    battery = db.Column(db.Integer) 
    promotion_text = db.Column(db.String(255))
    is_new = db.Column(db.Boolean, default=False)
    images = db.relationship('ProductImage', backref='product', lazy=True)
    order_details = db.relationship('OrderDetail', backref='product', cascade='all, delete-orphan')

class ProductImage(db.Model):
    __tablename__ = 'product_images'
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'))
    url = db.Column(db.String(255), nullable=False)
    description = db.Column(db.Text)

class Order(db.Model):
    __tablename__ = 'orders'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    order_date = db.Column(db.DateTime, default=datetime.utcnow)
    total = db.Column(db.Numeric(10, 2), nullable=False)
    status = db.Column(db.Enum('processing', 'shipped', 'cancelled'), nullable=False)
    order_details = db.relationship('OrderDetail', backref='order', lazy=True)
    payments = db.relationship('Payment', backref='order', lazy=True)
    address = db.Column(db.String(255))
class OrderDetail(db.Model):
    __tablename__ = 'order_details'
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'))
    product_id = db.Column(db.Integer, db.ForeignKey('products.id', ondelete='CASCADE'))
    quantity = db.Column(db.Integer, nullable=False)
    price = db.Column(db.Numeric(10, 2), nullable=False)
    discount = db.Column(db.Numeric(10, 2), default=0)

class Payment(db.Model):
    __tablename__ = 'payments'
    id = db.Column(db.Integer, primary_key=True)
    order_id = db.Column(db.Integer, db.ForeignKey('orders.id'))
    amount = db.Column(db.Numeric(10, 2), nullable=False)
    payment_date = db.Column(db.DateTime, default=datetime.utcnow)
    payment_method = db.Column(db.Enum('credit_card', 'paypal', 'cash'), nullable=False)

class Discount(db.Model):
    __tablename__ = 'discounts'
    id = db.Column(db.Integer, primary_key=True)
    description = db.Column(db.Text)
    discount_amount = db.Column(db.Numeric(10, 2), nullable=False)
    valid_from = db.Column(db.DateTime)
    valid_to = db.Column(db.DateTime)
    product_discounts = db.relationship('ProductDiscount', backref='discount', lazy=True)

class ProductDiscount(db.Model):
    __tablename__ = 'product_discounts'
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'), primary_key=True)
    discount_id = db.Column(db.Integer, db.ForeignKey('discounts.id'), primary_key=True)

class Rating(db.Model):
    __tablename__ = 'ratings'
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    score = db.Column(db.Integer, nullable=False)
    comment = db.Column(db.Text)
    rating_date = db.Column(db.DateTime, default=datetime.utcnow)

    user = db.relationship('User', backref=db.backref('ratings', lazy=True))
    product = db.relationship('Product', backref=db.backref('ratings', lazy=True))

class Brand(db.Model):
    __tablename__ = 'brands'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(255), nullable=False, unique=True)
    description = db.Column(db.Text)
    products = db.relationship('Product', backref='brand', lazy=True)
