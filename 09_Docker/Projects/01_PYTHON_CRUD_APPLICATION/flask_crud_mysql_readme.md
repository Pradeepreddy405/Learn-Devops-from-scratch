# Flask CRUD Application with MySQL

A simple **Flask-based CRUD (Create, Read, Update, Delete)** web application using **MySQL** as the database. This project allows you to **add, edit, and delete users** through a web interface with a clean Bootstrap UI.

---

## Table of Contents

1. [Project Structure](#project-structure)  
2. [Features](#features)  
3. [Requirements](#requirements)  
4. [Setup & Installation](#setup--installation)  
5. [MySQL Setup & Authentication Fix](#mysql-setup--authentication-fix)  
6. [Running the Application](#running-the-application)  
7. [Dockerization (Optional)](#dockerization-optional)  
8. [Usage](#usage)  
9. [Screenshots](#screenshots)  
10. [Notes](#notes)

---

## Project Structure

```
flask_crud_mysql/
├── app.py
├── models.py
├── config.py
├── requirements.txt
├── templates/
│   ├── base.html
│   ├── index.html
│   ├── add.html
│   └── edit.html
├── static/
│   └── css/
│       └── style.css (optional)
└── venv/
```

---

## Features

- Create a new user  
- View all users  
- Edit existing users  
- Delete users  
- Uses Flask for backend, MySQL for database  
- Responsive, clean UI using Bootstrap

---

## Requirements

- Python 3.x  
- Flask  
- Flask-SQLAlchemy  
- PyMySQL  
- cryptography (for MySQL 8+ authentication)  

Install dependencies:

```bash
pip install -r requirements.txt
```

---

## Setup & Installation

1. Clone the repository:

```bash
git clone <repository-url>
cd flask_crud_mysql
```

2. (Optional) Create a virtual environment:

```bash
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
venv\Scripts\activate     # Windows
```

3. Install dependencies:

```bash
pip install -r requirements.txt
```

---

## MySQL Setup & Authentication Fix

### 1️ Create MySQL Database and User

```sql
CREATE DATABASE flask_crud_db;

CREATE USER 'flaskuser'@'localhost' IDENTIFIED BY 'flaskpass';
GRANT ALL PRIVILEGES ON flask_crud_db.* TO 'flaskuser'@'localhost';
FLUSH PRIVILEGES;
```

### 2️ Fix `caching_sha2_password` Issue (MySQL 8+)

If you see this error:

```
RuntimeError: 'cryptography' package is required for caching_sha2_password auth methods
```

#### Option A: Install `cryptography`

```bash
pip install cryptography
```

Add it to `requirements.txt`:

```
cryptography
```

#### Option B: Change MySQL user to `mysql_native_password`

```sql
ALTER USER 'flaskuser'@'localhost'
IDENTIFIED WITH mysql_native_password
BY 'flaskpass';
FLUSH PRIVILEGES;
```

---

## Running the Application

Start the Flask server:

```bash
python app.py
```

Open your browser:

```
http://localhost:5000
```

> Flask must run with:
```python
app.run(host="0.0.0.0", port=5000, debug=True)
```
to access via public IP.

---

## Dockerization (Optional)

1. Build Docker image:

```bash
docker build -t flask-crud-app .
```

2. Run container:

```bash
docker run -d -p 5000:5000 flask-crud-app
```

Now accessible at:

```
http://localhost:5000
```

---

## Usage

- Go to the home page to see all users  
- Click **Add User** to create a new user  
- Click **Edit** to update a user  
- Click **Delete** to remove a user  

---

## Screenshots

> Add screenshots of:
- Home page (user list)
- Add user form
- Edit user form
- Responsive UI

---

## Notes

- **Database:** MySQL, `flask_crud_db`  
- **Models:** `models.py` defines the `User` table  
- **Templates:** Located in `templates/`  
- **Static files:** CSS in `static/css/` (optional)  
- **UI:** Bootstrap 5 for clean styling  

---

## References

- [Flask Documentation](https://flask.palletsprojects.com/)  
- [Flask-SQLAlchemy](https://flask-sqlalchemy.palletsprojects.com/)  
- [PyMySQL Docs](https://pymysql.readthedocs.io/)  

