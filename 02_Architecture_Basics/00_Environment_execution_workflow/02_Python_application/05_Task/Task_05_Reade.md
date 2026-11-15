# Task 05: Configure systemd Service for Python Application on Linux

## Objective

Configure a Python application as a Linux systemd service to run in the background, restart automatically on failure, and start automatically whenever the EC2 instance boots.

## 1. Create Python Application

```bash
cd ~/python-app
vi systemd_app.py
```

Add the following code:

```python
import time
from datetime import datetime

while True:
    print(
        f"Hello World from systemd Python Application! "
        f"Time: {datetime.now()}",
        flush=True
    )
    time.sleep(10)
```

## 2. Create systemd Service File

```bash
sudo vi /etc/systemd/system/python-app.service
```

Add the following configuration:

```ini
[Unit]
Description=Python Hello World Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/python-app
ExecStart=/usr/bin/python3 /home/ec2-user/python-app/systemd_app.py
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
```

## 3. Reload systemd Configuration

```bash
sudo systemctl daemon-reload
```

Reloads systemd so it recognizes the newly created service file.

## 4. Start the Python Service

```bash
sudo systemctl start python-app
```

Check service status:

```bash
sudo systemctl status python-app
```

Expected status:

```text
Active: active (running)
```

## 5. Enable Automatic Startup

```bash
sudo systemctl enable python-app
```

This enables the service to start automatically during system boot.

Verify:

```bash
sudo systemctl is-enabled