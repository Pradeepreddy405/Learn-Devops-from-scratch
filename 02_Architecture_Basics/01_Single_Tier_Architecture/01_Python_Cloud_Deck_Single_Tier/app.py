from datetime import datetime
from flask import Flask, render_template, request, redirect, url_for, flash
import sqlite3
import os

APP_DIR = os.path.dirname(os.path.abspath(__file__))
DB_PATH = os.environ.get("DATABASE_PATH", os.path.join(APP_DIR, "clouddeck.db"))
app = Flask(__name__)
app.secret_key = os.environ.get("SECRET_KEY", "change-this-before-production")

SERVICES = [
    {"name": "Web Application", "kind": "Flask", "status": "Operational", "detail": "Serving HTTP traffic", "icon": "🌐"},
    {"name": "Database", "kind": "SQLite", "status": "Operational", "detail": "Local application data", "icon": "🗄️"},
    {"name": "Deployment Agent", "kind": "Demo", "status": "Ready", "detail": "Deployment activity simulator", "icon": "🚀"},
    {"name": "Monitoring", "kind": "Built-in", "status": "Operational", "detail": "Application-level checks", "icon": "📈"},
]

def db():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    with db() as conn:
        conn.execute("""CREATE TABLE IF NOT EXISTS deployments (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            app_name TEXT NOT NULL,
            environment TEXT NOT NULL,
            version TEXT NOT NULL,
            status TEXT NOT NULL,
            created_at TEXT NOT NULL
        )""")
        count = conn.execute("SELECT COUNT(*) FROM deployments").fetchone()[0]
        if count == 0:
            samples = [
                ("payments-api", "Production", "v2.4.1", "Successful", "2026-11-15 09:42"),
                ("customer-portal", "Staging", "v1.8.0", "Successful", "2026-11-14 16:18"),
                ("inventory-worker", "Development", "v0.9.7", "Rolled back", "2026-11-14 11:05"),
            ]
            conn.executemany("INSERT INTO deployments(app_name,environment,version,status,created_at) VALUES(?,?,?,?,?)", samples)

@app.route("/")
def index():
    with db() as conn:
        deployments = conn.execute("SELECT * FROM deployments ORDER BY id DESC LIMIT 8").fetchall()
        total = conn.execute("SELECT COUNT(*) FROM deployments").fetchone()[0]
        successful = conn.execute("SELECT COUNT(*) FROM deployments WHERE status='Successful'").fetchone()[0]
        failed = conn.execute("SELECT COUNT(*) FROM deployments WHERE status='Failed'").fetchone()[0]
    return render_template("index.html", deployments=deployments, total=total,
                           successful=successful, failed=failed, services=SERVICES,
                           now=datetime.now().strftime("%d %b %Y, %I:%M %p"))

@app.post("/deploy")
def deploy():
    app_name = request.form.get("app_name", "").strip()
    environment = request.form.get("environment", "Development")
    version = request.form.get("version", "").strip()
    if not app_name or not version:
        flash("Application name and version are required.", "error")
        return redirect(url_for("index"))
    if len(app_name) > 60 or len(version) > 30:
        flash("Please keep the application name and version within the displayed limits.", "error")
        return redirect(url_for("index"))
    with db() as conn:
        conn.execute(
            "INSERT INTO deployments(app_name,environment,version,status,created_at) VALUES(?,?,?,?,?)",
            (app_name, environment, version, "Successful", datetime.now().strftime("%Y-%m-%d %H:%M"))
        )
    flash(f"Demo deployment of {app_name} {version} recorded successfully.", "success")
    return redirect(url_for("index"))

@app.get("/health")
def health():
    return {"status": "ok", "application": "CloudDeck", "database": "sqlite", "checked_at": datetime.utcnow().isoformat() + "Z"}

@app.get("/architecture")
def architecture():
    return render_template("architecture.html")

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", "5000")), debug=False)
