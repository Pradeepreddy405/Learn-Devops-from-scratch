# Cloud Deck — Cloud & DevOps Control Center

A small, polished Python + Flask application designed for learning **single-tier deployment** on one cloud VM (for example, one AWS EC2 instance).

## What it includes

- Cloud/DevOps-themed dashboard
- Deployment activity table backed by SQLite
- Demo deployment form (records a release; it does **not** deploy infrastructure)
- Service-health overview
- JSON health endpoint at `/health`
- Single-tier architecture page at `/architecture`
- Responsive layout for desktop and mobile

## Architecture

```text
User browser
    |
    | HTTP
    v
One EC2 / Linux VM
    |
    +-- Flask application
    |     +-- HTML/Jinja templates
    |     +-- Python routes and application logic
    |
    +-- SQLite database file (clouddeck.db)
    |
    +-- Static CSS
```

All application components run on the same instance. SQLite is embedded and stores data in a local file.

## Run locally

Python 3.10+ recommended.

```bash
python3 -m venv .venv
source .venv/bin/activate        # Windows: .venv\\Scripts\\activate
pip install -r requirements.txt
python app.py
```

Open `http://127.0.0.1:5000`.

## Deploy on one Ubuntu EC2 instance

### 1. Connect and install prerequisites

```bash
sudo apt update
sudo apt install -y python3 python3-venv python3-pip
```

### 2. Copy the project to the instance

Upload/extract this project, then:

```bash
cd clouddeck-single-tier
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

### 3. Test the app

```bash
python app.py
```

Visit `http://EC2_PUBLIC_IP:5000`. For this temporary test, allow inbound TCP 5000 from **your IP only** in the EC2 security group. Stop the foreground process with `Ctrl+C`.

### 4. Run with Gunicorn

```bash
. .venv/bin/activate
pip install gunicorn
gunicorn --workers 2 --bind 0.0.0.0:8000 app:app
```

Allow inbound TCP 8000 from your IP for a quick test, then visit `http://EC2_PUBLIC_IP:8000`.

### 5. Keep it running with systemd

Create `/etc/systemd/system/clouddeck.service` (update the path and Linux username):

```ini
[Unit]
Description=CloudDeck Flask application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/clouddeck-single-tier
Environment=SECRET_KEY=replace-with-a-long-random-value
Environment=DATABASE_PATH=/home/ubuntu/clouddeck-single-tier/clouddeck.db
ExecStart=/home/ubuntu/clouddeck-single-tier/.venv/bin/gunicorn --workers 2 --bind 0.0.0.0:8000 app:app
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Then run:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now clouddeck
sudo systemctl status clouddeck
journalctl -u clouddeck -f
```

Check the health endpoint:

```bash
curl http://127.0.0.1:8000/health
```

For a real public deployment, put Nginx in front for HTTPS and proxying, restrict security-group access to the required ports, use a strong secret, and back up the SQLite database. Do not expose Flask's development server to the public internet.

## Useful endpoints

| Path | Purpose |
|---|---|
| `/` | Main dashboard |
| `/architecture` | Single-tier architecture explanation |
| `/health` | JSON health check |
| `/deploy` | POST form endpoint to record a demo deployment |

## Important limitations

This is a learning/demo application. The deployment form only writes a record to SQLite; it does not call AWS, build containers, or deploy code. The service status cards are illustrative, not real infrastructure monitoring. The app has no authentication, authorization, CSRF protection, or production-grade audit trail. Add those before using it with real users or sensitive data.
