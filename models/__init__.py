from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime
import random, string

db = SQLAlchemy()

class AdminUser(db.Model, UserMixin):
    __tablename__ = 'admin_users'
    id            = db.Column(db.Integer, primary_key=True)
    username      = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    full_name     = db.Column(db.String(120))
    email         = db.Column(db.String(120))
    is_active     = db.Column(db.Boolean, default=True)
    last_login    = db.Column(db.DateTime)
    created_at    = db.Column(db.DateTime, default=datetime.utcnow)

    def set_password(self, p): self.password_hash = generate_password_hash(p, method='pbkdf2:sha256')
    def check_password(self, p): return check_password_hash(self.password_hash, p)
    def get_id(self): return f'admin_{self.id}'

class User(db.Model, UserMixin):
    __tablename__ = 'users'
    id            = db.Column(db.Integer, primary_key=True)
    email         = db.Column(db.String(150), unique=True, nullable=False)
    password_hash = db.Column(db.String(256), nullable=False)
    full_name     = db.Column(db.String(150))
    phone         = db.Column(db.String(20))
    is_active     = db.Column(db.Boolean, default=True)
    created_at    = db.Column(db.DateTime, default=datetime.utcnow)
    last_login    = db.Column(db.DateTime)
    orders        = db.relationship('Order', backref='user', lazy=True)
    carts         = db.relationship('Cart', backref='user', lazy=True, cascade='all, delete-orphan')
    addresses     = db.relationship(
        'UserAddress', backref='user', lazy=True, cascade='all, delete-orphan',
        order_by='UserAddress.is_default.desc(), UserAddress.created_at.asc()'
    )

    def set_password(self, p): self.password_hash = generate_password_hash(p, method='pbkdf2:sha256')
    def check_password(self, p): return check_password_hash(self.password_hash, p)
    def get_id(self): return f'user_{self.id}'

class UserAddress(db.Model):
    __tablename__ = 'user_addresses'
    id           = db.Column(db.Integer, primary_key=True)
    user_id      = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    label        = db.Column(db.String(60))
    full_name    = db.Column(db.String(150), nullable=False)
    phone        = db.Column(db.String(20), nullable=False)
    address_line = db.Column(db.Text, nullable=False)
    city         = db.Column(db.String(100))
    pincode      = db.Column(db.String(10))
    is_default   = db.Column(db.Boolean, default=False)
    created_at   = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at   = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    def to_dict(self):
        return {
            'id':           self.id,
            'label':        self.label or '',
            'full_name':    self.full_name,
            'phone':        self.phone,
            'address_line': self.address_line,
            'city':         self.city or '',
            'pincode':      self.pincode or '',
            'is_default':   self.is_default,
        }

class Setting(db.Model):
    __tablename__ = 'settings'
    id         = db.Column(db.Integer, primary_key=True)
    key_name   = db.Column(db.String(100), unique=True, nullable=False)
    value      = db.Column(db.Text)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    @classmethod
    def get(cls, key, default=''):
        row = cls.query.filter_by(key_name=key).first()
        return row.value if row else default

    @classmethod
    def set(cls, key, value):
        row = cls.query.filter_by(key_name=key).first()
        if row:
            row.value = value
        else:
            row = cls(key_name=key, value=value)
            db.session.add(row)
        db.session.commit()

    @classmethod
    def all_dict(cls):
        return {r.key_name: r.value for r in cls.query.all()}

class Category(db.Model):
    __tablename__ = 'categories'
    id          = db.Column(db.Integer, primary_key=True)
    name        = db.Column(db.String(100), nullable=False)
    slug        = db.Column(db.String(100), unique=True, nullable=False)
    description = db.Column(db.Text)
    sort_order  = db.Column(db.Integer, default=0)
    is_active   = db.Column(db.Boolean, default=True)
    products    = db.relationship('Product', backref='category', lazy=True)

class ProductRelated(db.Model):
    __tablename__ = 'product_related'
    id         = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    related_id = db.Column(db.Integer, db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    sort_order = db.Column(db.Integer, default=0)

class Product(db.Model):
    __tablename__ = 'products'
    id              = db.Column(db.Integer, primary_key=True)
    category_id     = db.Column(db.Integer, db.ForeignKey('categories.id'))
    name            = db.Column(db.String(200), nullable=False)
    slug            = db.Column(db.String(200), unique=True, nullable=False)
    short_desc      = db.Column(db.String(300))
    subtitle        = db.Column(db.String(300))
    offer_label     = db.Column(db.String(100))
    stock_label     = db.Column(db.String(100))
    delivery_text   = db.Column(db.String(200))
    freshness_text  = db.Column(db.String(200))
    highlights      = db.Column(db.Text)
    weight_label    = db.Column(db.String(100))
    size_label_text = db.Column(db.String(100))
    delivery_charge = db.Column(db.Numeric(10, 2), default=0)
    description     = db.Column(db.Text)
    emoji           = db.Column(db.String(10), default='🌾')
    image_filename  = db.Column(db.String(255))
    badge           = db.Column(db.String(50))
    badge_color     = db.Column(db.String(20), default='#4A7C59')
    is_active       = db.Column(db.Boolean, default=True)
    is_featured     = db.Column(db.Boolean, default=False)
    sort_order      = db.Column(db.Integer, default=0)
    created_at      = db.Column(db.DateTime, default=datetime.utcnow)
    variants        = db.relationship('ProductVariant', backref='product',
                                      lazy=True, cascade='all, delete-orphan')

    @property
    def default_variant(self):
        v = ProductVariant.query.filter_by(product_id=self.id, is_default=True).first()
        return v or (self.variants[0] if self.variants else None)

    @property
    def image_url(self):
        if self.image_filename:
            return f'/static/uploads/products/{self.image_filename}'
        return None

    @property
    def highlights_list(self):
        if not self.highlights:
            return []
        return [h.strip() for h in self.highlights.splitlines() if h.strip()]

    @property
    def related_products(self):
        rows = (ProductRelated.query
                .filter_by(product_id=self.id)
                .order_by(ProductRelated.sort_order)
                .all())
        if not rows:
            return []
        related_ids = [r.related_id for r in rows]
        products = Product.query.filter(
            Product.id.in_(related_ids),
            Product.is_active == True
        ).all()
        order_map = {r.related_id: r.sort_order for r in rows}
        return sorted(products, key=lambda p: order_map.get(p.id, 0))

    @property
    def gallery_images(self):
        """Return active gallery images ordered by sort_order."""
        from models import ProductImage as _PI
        return (_PI.query
                .filter_by(product_id=self.id, is_active=True)
                .order_by(_PI.sort_order, _PI.id)
                .all())

    @property
    def all_gallery_images(self):
        """Return ALL gallery images including hidden, for admin."""
        from models import ProductImage as _PI
        return (_PI.query
                .filter_by(product_id=self.id)
                .order_by(_PI.sort_order, _PI.id)
                .all())

    @property
    def cover_image_url(self):
        """
        Best cover image URL for cards/thumbnails.
        Priority: primary gallery image > first active gallery > image_filename field > None
        """
        from models import ProductImage as _PI
        primary = (_PI.query
                   .filter_by(product_id=self.id, is_primary=True, is_active=True)
                   .first())
        if primary:
            return primary.url
        first_active = (_PI.query
                        .filter_by(product_id=self.id, is_active=True)
                        .order_by(_PI.sort_order, _PI.id)
                        .first())
        if first_active:
            return first_active.url
        return self.image_url  # fallback to old single-image field

class ProductVariant(db.Model):
    __tablename__ = 'product_variants'
    id         = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id'), nullable=False)
    size_label = db.Column(db.String(50), nullable=False)
    weight_kg  = db.Column(db.Numeric(5, 2))
    price      = db.Column(db.Numeric(10, 2), nullable=False)
    mrp        = db.Column(db.Numeric(10, 2))
    stock_qty  = db.Column(db.Integer, default=100)
    is_default = db.Column(db.Boolean, default=False)

    @property
    def discount_pct(self):
        if self.mrp and float(self.mrp) > float(self.price):
            return int((1 - float(self.price) / float(self.mrp)) * 100)
        return 0

class Cart(db.Model):
    __tablename__ = 'carts'
    __table_args__ = (db.UniqueConstraint('user_id', 'variant_id', name='uq_cart_user_variant'),)
    id         = db.Column(db.Integer, primary_key=True)
    user_id    = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    variant_id = db.Column(db.Integer, db.ForeignKey('product_variants.id'), nullable=False)
    quantity   = db.Column(db.Integer, default=1, nullable=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    variant    = db.relationship('ProductVariant', backref='cart_items')

class WhyCard(db.Model):
    __tablename__ = 'why_cards'
    id          = db.Column(db.Integer, primary_key=True)
    icon        = db.Column(db.String(10), nullable=False)
    title       = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    sort_order  = db.Column(db.Integer, default=0)
    is_active   = db.Column(db.Boolean, default=True)

class ProcessStep(db.Model):
    __tablename__ = 'process_steps'
    id          = db.Column(db.Integer, primary_key=True)
    step_number = db.Column(db.Integer, nullable=False)
    title       = db.Column(db.String(100), nullable=False)
    description = db.Column(db.Text)
    is_active   = db.Column(db.Boolean, default=True)

class Testimonial(db.Model):
    __tablename__ = 'testimonials'
    id             = db.Column(db.Integer, primary_key=True)
    reviewer_name  = db.Column(db.String(100), nullable=False)
    reviewer_city  = db.Column(db.String(100))
    avatar_initial = db.Column(db.String(1))
    rating         = db.Column(db.Integer, default=5)
    review_text    = db.Column(db.Text, nullable=False)
    is_active      = db.Column(db.Boolean, default=True)
    sort_order     = db.Column(db.Integer, default=0)
    created_at     = db.Column(db.DateTime, default=datetime.utcnow)

class FooterLink(db.Model):
    __tablename__ = 'footer_links'
    id          = db.Column(db.Integer, primary_key=True)
    column_name = db.Column(db.String(50), nullable=False)
    label       = db.Column(db.String(100), nullable=False)
    url         = db.Column(db.String(200), nullable=False)
    sort_order  = db.Column(db.Integer, default=0)
    is_active   = db.Column(db.Boolean, default=True)

class Order(db.Model):
    __tablename__ = 'orders'
    id               = db.Column(db.Integer, primary_key=True)
    user_id          = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    order_number     = db.Column(db.String(20), unique=True, nullable=False)
    customer_name    = db.Column(db.String(150), nullable=False)
    customer_phone   = db.Column(db.String(20), nullable=False)
    customer_email   = db.Column(db.String(150))
    delivery_address = db.Column(db.Text, nullable=False)
    city             = db.Column(db.String(100))
    pincode          = db.Column(db.String(10))
    subtotal         = db.Column(db.Numeric(10, 2), nullable=False)
    delivery_charge  = db.Column(db.Numeric(10, 2), default=0)
    total_amount     = db.Column(db.Numeric(10, 2), nullable=False)
    payment_method   = db.Column(db.String(50), default='COD')
    status           = db.Column(db.String(20), default='pending')
    notes            = db.Column(db.Text)
    created_at       = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at       = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    items            = db.relationship('OrderItem', backref='order',
                                       lazy=True, cascade='all, delete-orphan')

    STATUS_COLORS = {
        'pending':    '#C8922A',
        'confirmed':  '#3B82F6',
        'processing': '#8B5CF6',
        'shipped':    '#F59E0B',
        'delivered':  '#4A7C59',
        'cancelled':  '#EF4444',
    }

    @property
    def status_color(self):
        return self.STATUS_COLORS.get(self.status, '#888')

def generate_order_number():
    suffix = ''.join(random.choices(string.ascii_uppercase + string.digits, k=6))
    return f"CP{datetime.utcnow().strftime('%y%m%d')}{suffix}"

class OrderItem(db.Model):
    __tablename__ = 'order_items'
    id            = db.Column(db.Integer, primary_key=True)
    order_id      = db.Column(db.Integer, db.ForeignKey('orders.id'), nullable=False)
    product_id    = db.Column(db.Integer, db.ForeignKey('products.id'), nullable=False)
    variant_id    = db.Column(db.Integer, db.ForeignKey('product_variants.id'), nullable=False)
    product_name  = db.Column(db.String(200))
    variant_label = db.Column(db.String(50))
    quantity      = db.Column(db.Integer, nullable=False)
    unit_price    = db.Column(db.Numeric(10, 2), nullable=False)
    subtotal      = db.Column(db.Numeric(10, 2), nullable=False)

class OrderReview(db.Model):
    __tablename__ = 'order_reviews'
    id          = db.Column(db.Integer, primary_key=True)
    order_id    = db.Column(db.Integer, db.ForeignKey('orders.id'), unique=True, nullable=False)
    user_id     = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=False)
    rating      = db.Column(db.Integer, nullable=False)
    review_text = db.Column(db.Text, nullable=False)
    created_at  = db.Column(db.DateTime, default=datetime.utcnow)
    order       = db.relationship('Order', backref=db.backref('review', uselist=False))
    user        = db.relationship('User', backref='reviews')

class ProductImage(db.Model):
    __tablename__ = 'product_images'
    id         = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('products.id', ondelete='CASCADE'), nullable=False)
    filename   = db.Column(db.String(255), nullable=False)
    alt_text   = db.Column(db.String(200))
    is_primary = db.Column(db.Boolean, default=False)
    is_active  = db.Column(db.Boolean, default=True)
    sort_order = db.Column(db.Integer, default=0)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    @property
    def url(self):
        return f'/static/uploads/products/{self.filename}'