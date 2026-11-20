# Task 5 — systemd service

## 1. Create and publish
```bash
cd ~/dotnet-app
dotnet new console -n Task5Systemd
cd Task5Systemd
dotnet publish -c Release -o /home/ec2-user/dotnet-publish/Task5Systemd
```
Replace `Program.cs` with this folder's source before publishing.

## 2. Find dotnet path
```bash
command -v dotnet
```
Use the returned path in `ExecStart` below (example: `/usr/bin/dotnet`).

## 3. Create service
```bash
sudo vi /etc/systemd/system/dotnet-task5.service
```
Add:
```ini
[Unit]
Description=DotNet Task 5 Application
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/dotnet-publish/Task5Systemd
ExecStart=/usr/bin/dotnet /home/ec2-user/dotnet-publish/Task5Systemd/Task5Systemd.dll
Restart=on-failure
RestartSec=5
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```
If `command -v dotnet` returned another path, replace `/usr/bin/dotnet`.

## 4. Reload, enable and start
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now dotnet-task5.service
```
`daemon-reload` reads the new unit. `enable` configures boot startup. `--now` starts it immediately.

## 5. Verify and monitor
```bash
sudo systemctl status dotnet-task5
sudo systemctl is-enabled dotnet-task5
sudo journalctl -u dotnet-task5 -f
```
Press `Ctrl+C` to exit log viewing, not to stop the service.

## 6. Test restart-on-failure
Find the dotnet process for this DLL:
```bash
pgrep -af 'Task5Systemd.dll'
```
Terminate that process (not the shell) to simulate a crash:
```bash
sudo kill -9 <PID>
```
Wait five seconds, then:
```bash
sudo systemctl status dotnet-task5
sudo journalctl -u dotnet-task5 -n 30 --no-pager
```
Do not use `systemctl stop` for this test; an intentional stop is not a failure.

## 7. Test boot startup
Confirm:
```bash
sudo systemctl is-enabled dotnet-task5
```
When ready and sure you can reconnect:
```bash
sudo reboot
```
Reconnect and check:
```bash
sudo systemctl status dotnet-task5
sudo journalctl -u dotnet-task5 -b --no-pager
```

## Useful commands
```bash
sudo systemctl start dotnet-task5
sudo systemctl stop dotnet-task5
sudo systemctl restart dotnet-task5
sudo systemctl disable --now dotnet-task5
```

## Remove service
```bash
sudo systemctl disable --now dotnet-task5.service
sudo rm -f /etc/systemd/system/dotnet-task5.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
```

This is a learning example. Production services should use a dedicated non-login account, least-privilege permissions, secret management, monitoring and log retention.
