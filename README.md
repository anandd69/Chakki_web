# Chakki Premium - Full Stack eCommerce Platform

A production-ready Flask-based eCommerce platform for selling chakki atta (wheat flour) online.

## Features

- ✅ Complete user authentication (register, login, logout)
- ✅ Admin authentication with separate dashboard
- ✅ Role-based access control (Admin vs User)
- ✅ Database-backed cart system (persistent for logged-in users)
- ✅ Session-based cart for guests
- ✅ Product management (CRUD operations)
- ✅ Order management system
- ✅ User dashboard with order history
- ✅ Order tracking
- ✅ Analytics dashboard for admins
- ✅ Fully responsive templates

## Tech Stack

- **Backend**: Flask 3.0.2
- **Database**: MySQL 8.0+
- **ORM**: SQLAlchemy
- **Authentication**: Flask-Login
- **Security**: Flask-WTF (CSRF protection), Werkzeug (password hashing)

## Installation

### 1. Clone/Extract the project

```bash
cd chakki-premium
```

### 2. Create virtual environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure database

Create a MySQL database:

```sql
CREATE DATABASE chakki_db1 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 5. Import database schema

```bash
mysql -u root -p chakki_db1 < database.sql
```

### 6. Configure environment

Copy `.env.example` to `.env` and update with your settings:

```bash
cp .env.example .env
```

Edit `.env`:
```
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=chakki_db1
SECRET_KEY=your-secret-key-here
```

### 7. Run the application

```bash
python app.py
```

The application will be available at: `http://localhost:5000`

**⚠️ Change the default admin password immediately in production!**

## Project Structure

```
chakki-premium/
├── app.py                 # Main application file
├── config.py              # Configuration
├── models.py              # Database models (updated)
├── requirements.txt       # Python dependencies
├── database.sql           # Database schema
├── routes/
│   ├── auth.py           # User authentication routes (NEW)
│   ├── user.py           # User dashboard routes (NEW)
│   ├── shop.py           # Shop routes (updated)
│   └── admin.py          # Admin routes (updated)
├── templates/
│   ├── auth/
│   │   ├── login.html    # User login (NEW)
│   │   └── register.html # User registration (NEW)
│   ├── user/
│   │   ├── dashboard.html    # User dashboard (NEW)
│   │   └── order_detail.html # User order detail (NEW)
│   ├── admin/            # Admin templates
│   └── ...               # Other templates
└── static/
    ├── css/
    └── js/
```

## Key Changes from Original

### 1. **User Authentication System**
- New `User` model for customers
- Separate login/register routes
- Role-based access control
- Session management

### 2. **Database-Backed Cart**
- `Cart` model for persistent cart storage
- Guest cart stored in session
- Cart merges when guest logs in

### 3. **Enhanced Security**
- Password hashing with Werkzeug
- CSRF protection
- Role-based route protection
- Secure session handling

### 4. **User Features**
- Personal dashboard
- Order history
- Order tracking

### 5. **Admin Improvements**
- Separate admin authentication
- Admin-only route protection
- Cannot access user area

## API Endpoints

### Public Routes
- `GET /` - Homepage
- `GET /products` - Product listing
- `GET /products/<slug>` - Product detail
- `GET /cart` - View cart
- `POST /add-to-cart` - Add to cart
- `POST /update-cart` - Update cart
- `GET /checkout` - Checkout page
- `POST /place-order` - Place order
- `GET /track-order` - Track order

### Auth Routes
- `GET /auth/login` - User login page
- `POST /auth/login` - User login
- `GET /auth/register` - User registration page
- `POST /auth/register` - User registration
- `GET /auth/logout` - User logout

### User Routes (Login Required)
- `GET /user/dashboard` - User dashboard
- `GET /user/orders` - User orders
- `GET /user/orders/<order_number>` - Order detail

### Admin Routes (Admin Login Required)
- `GET /admin/login` - Admin login
- `GET /admin/dashboard` - Admin dashboard
- `GET /admin/products` - Product management
- `GET /admin/orders` - Order management
- `GET /admin/analytics` - Analytics

## Production Deployment

1. **Update configuration**
   - Set `FLASK_ENV=production` in `.env`
   - Change `SECRET_KEY` to a strong random value
   - Update database credentials

2. **Change default admin password**
   - Login to admin panel
   - Change password immediately

3. **Use a production server**
   - Gunicorn: `gunicorn -w 4 -b 0.0.0.0:5000 app:app`
   - uWSGI or similar

4. **Set up SSL/HTTPS**
   - Use reverse proxy (Nginx/Apache)
   - Enable SSL certificates

5. **Database optimization**
   - Add proper indexes
   - Enable query caching
   - Regular backups

## Security Notes

- All passwords are hashed using PBKDF2-SHA256
- CSRF protection enabled on all forms
- SQL injection prevention through SQLAlchemy ORM
- Session-based authentication
- Role-based access control

## Support

For issues or questions, check the code comments or Flask documentation.

## License

Proprietary - All rights reserved
