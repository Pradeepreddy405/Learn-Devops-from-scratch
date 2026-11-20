# Task 5 — Node.js with systemd

## Objective
Run a long-lived Node.js application as a Linux service.

## 1. Confirm project location and Node path

This example assumes:

```text
/home/ec2-user/nodejs-practice
```

Check Node.js:

```bash
which node
```

Use the actual path in `ExecStart`.

## 2. Create the service unit

```bash
sudo vi /etc/systemd/system/nodejs-monitor.service
```

Unit file:

```ini
[Unit]
Description=Node.js Application Monitor
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/nodejs-practice
ExecStart=/usr/bin/node /home/ec2-user/nodejs-practice/task5-systemd/app.js
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

Adjust `User`, both project paths, and `/usr/bin/node` to match your machine.

## 3. Manage the service

```bash
sudo systemctl daemon-reload
sudo systemctl start nodejs-monitor
sudo systemctl status nodejs-monitor
sudo systemctl enable nodejs-monitor
```

## 4. View logs

```bash
sudo journalctl -u nodejs-monitor
sudo journalctl -u nodejs-monitor -f
sudo journalctl -u nodejs-monitor -n 50
```

## 5. Stop, restart, or disable

```bash
sudo systemctl stop nodejs-monitor
sudo systemctl restart nodejs-monitor
sudo systemctl disable nodejs-monitor
```

After editing the service unit, run `sudo systemctl daemon-reload` and restart the service.

## Key learning
`systemd` supervises the foreground process, can restart it after failure when configured, integrates with journald, and can start it at boot when enabled. Run services as an unprivileged account where possible.
