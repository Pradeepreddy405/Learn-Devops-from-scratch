from flask import Flask, render_template, request, redirect, url_for
from config import Config
from models import db, User
from sqlalchemy.exc import OperationalError
import time

app = Flask(__name__)
app.config.from_object(Config)

db.init_app(app)

# ✅ MySQL readiness wait loop (Flask 3 compatible)
def wait_for_db(app, retries=10, delay=5):
    while retries > 0:
        try:
            with app.app_context():
                db.create_all()
            print("✅ Database connected & tables created")
            return
        except OperationalError:
            retries -= 1
            print("⏳ Waiting for MySQL to be ready...")
            time.sleep(delay)

# 🚀 Call BEFORE app starts serving
wait_for_db(app)

@app.route("/")
def index():
    users = User.query.all()
    return render_template("index.html", users=users)

@app.route("/add", methods=["GET", "POST"])
def add_user():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        user = User(name=name, email=email)
        db.session.add(user)
        db.session.commit()
        return redirect(url_for("index"))
    return render_template("add.html")

@app.route("/edit/<int:id>", methods=["GET", "POST"])
def edit_user(id):
    user = User.query.get_or_404(id)

    if request.method == "POST":
        user.name = request.form["name"]
        user.email = request.form["email"]
        db.session.commit()
        return redirect(url_for("index"))

    return render_template("edit.html", user=user)

@app.route("/delete/<int:id>")
def delete_user(id):
    user = User.query.get_or_404(id)
    db.session.delete(user)
    db.session.commit()
    return redirect(url_for("index"))

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)