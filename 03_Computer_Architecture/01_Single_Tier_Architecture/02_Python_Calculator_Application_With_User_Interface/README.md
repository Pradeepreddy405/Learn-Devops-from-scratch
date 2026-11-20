# Python Calculator – Flask Application Deployment on AWS EC2

## 1. Project Overview

This project demonstrates deploying a Python Flask Calculator application on an AWS EC2 Ubuntu instance.

The application uses:

- **Python 3** – Programming language
- **Flask** – Web application framework
- **Gunicorn** – WSGI application server
- **systemd** – Linux service management
- **Ubuntu Linux** – Operating system
- **AWS EC2** – Cloud infrastructure

### Deployment Architecture

```text
              User / Browser
                    |
                    |
              AWS EC2 Instance
                    |
                    |
              Ubuntu Linux
                    |
                    |
              systemd Service
                    |
                    |
                Gunicorn
                    |
                    |
              Flask Application
                    |
                    |
             Python Calculator
```

Application port: `5000`

## 2. Clone the GitHub Repository

```bash
git clone https://github.com/Pradeepreddy405/Python_Calculator.git
```

Navigate to the application directory:

```bash
cd Python_Calculator/Python_Application
```

Project directory structure:

```text
Python_Application/
│
├── app.py
├── requirements.py
├── static/
├── templates/
├── venv/
└── logs/
```

## 3. Install Python Virtual Environment Support

Update Ubuntu package information:

```bash
sudo apt update
```

Install virtual environment support:

```bash
sudo apt install python3-venv -y
```

## 4. Create a Python Virtual Environment

Create the virtual environment:

```bash
python3 -m venv venv
```

Activate it:

```bash
source venv/bin/activate
```

Verify Python:

```bash
python --version
```

## 5. Install Application Dependencies

Install the dependencies declared in `requirements.py`:

```bash
pip install -r requirements.py
```

The dependencies include:

- Flask
- Gunicorn

## 6. Test the Flask Application

Start the application manually:

```bash
python app.py
```

The Flask application listens on port `5000`.

Open another SSH terminal and test the health endpoint:

```bash
curl http://127.0.0.1:5000/health
```

Expected response:

```json
{"status":"healthy"}
```

Test the calculator endpoint:

```bash
curl -X POST http://127.0.0.1:5000/calculate \
-H "Content-Type: application/json" \
-d '{"expression":"10+20"}'
```

Expected response:

```json
{"result":30,"success":true}
```

Stop the foreground application using:

```text
CTRL + C
```

## 7. Run the Application in the Background

Start the application using `nohup`:

```bash
nohup python app.py > app.log 2>&1 &
```

Check the running process:

```bash
ps -ef | grep '[p]ython app.py'
```

View application logs:

```bash
tail -f app.log
```

Note: We use systemd in the following steps for persistent service management instead of relying on nohup.

## 8. Create a Logs Directory

Create the application log directory:

```bash
mkdir -p logs
```

Set directory ownership:

```bash
sudo chown -R ubuntu:ubuntu logs
```

Log directory structure:

```text
Python_Application/
│
├── app.py
├── requirements.py
├── venv/
│
└── logs/
    ├── app.log
    └── error.log
```

## 9. Install and Verify Gunicorn

Check Gunicorn:

```bash
./venv/bin/gunicorn --version
```

If it is not installed:

```bash
./venv/bin/pip install gunicorn
```

## 10. Create a systemd Service File

Create the service file:

```bash
sudo nano /etc/systemd/system/python-calculator.service
```

Add the following configuration:

```ini
[Unit]
Description=Python Calculator Flask Application
After=network.target

[Service]
User=ubuntu
Group=ubuntu

WorkingDirectory=/home/ubuntu/Python_Calculator/Python_Application

Environment="PYTHONUNBUFFERED=1"

ExecStart=/home/ubuntu/Python_Calculator/Python_Application/venv/bin/gunicorn \
    --workers 2 \
    --bind 0.0.0.0:5000 \
    app:app

StandardOutput=append:/home/ubuntu/Python_Calculator/Python_Application/logs/app.log
StandardError=append:/home/ubuntu/Python_Calculator/Python_Application/logs/error.log

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Save the file:

```text
CTRL + O
ENTER
CTRL + X
```

### Explanation of Service Configuration

| Configuration | Description |
|---|---|
| `[Unit]` | Defines service information and dependencies |
| `Description` | Service description |
| `After=network.target` | Starts after the network target |
| `User=ubuntu` | Runs the application as ubuntu |
| `Group=ubuntu` | Uses the ubuntu group |
| `WorkingDirectory` | Application working directory |
| `Environment` | Sets environment variables |
| `ExecStart` | Command used to start Gunicorn |
| `--workers 2` | Runs two worker processes |
| `--bind 0.0.0.0:5000` | Listens on port 5000 |
| `app:app` | Loads the Flask app object from app.py |
| `StandardOutput` | Stores standard output in app.log |
| `StandardError` | Stores error output in error.log |
| `Restart=always` | Automatically restarts the service when it exits |
| `RestartSec=5` | Waits five seconds before restarting |
| `[Install]` | Defines the service installation target |
| `WantedBy=multi-user.target` | Enables automatic startup at boot |

## 11. Reload systemd Configuration

After creating or modifying the service file:

```bash
sudo systemctl daemon-reload
```

This instructs systemd to reload service configuration files.

## 12. Enable the Service

```bash
sudo systemctl enable python-calculator
```

This configures the application to start automatically during system boot.

## 13. Start the Application

```bash
sudo systemctl start python-calculator
```

## 14. Check Application Status

```bash
sudo systemctl status python-calculator
```

Expected status:

```text
Active: active (running)
```

## 15. Test the Application

Health check:

```bash
curl http://127.0.0.1:5000/health
```

Expected response:

```json
{"status":"healthy"}
```

## 16. Application Log Management

Application output:

```bash
tail -f /home/ubuntu/Python_Calculator/Python_Application/logs/app.log
```

Application errors:

```bash
tail -f /home/ubuntu/Python_Calculator/Python_Application/logs/error.log
```

Display the last 50 lines:

```bash
tail -n 50 logs/app.log
```

View systemd journal logs:

```bash
sudo journalctl -u python-calculator
```

Follow live service logs:

```bash
sudo journalctl -u python-calculator -f
```

## 17. systemd Service Management Commands

| Command | Purpose |
|---|---|
| `sudo systemctl start python-calculator` | Start application |
| `sudo systemctl stop python-calculator` | Stop application |
| `sudo systemctl restart python-calculator` | Restart application |
| `sudo systemctl status python-calculator` | Check service status |
| `sudo systemctl enable python-calculator` | Enable automatic startup |
| `sudo systemctl disable python-calculator` | Disable automatic startup |
| `sudo systemctl daemon-reload` | Reload service configuration |

## 18. Test Automatic Startup After Reboot

Reboot the EC2 instance:

```bash
sudo reboot
```

Reconnect to your EC2 instance using SSH.

Check the service:

```bash
sudo systemctl status python-calculator
```

Test the application:

```bash
curl http://127.0.0.1:5000/health
```

If the service is active and the health check succeeds, automatic startup is working.

## 19. AWS Security Group Configuration

To access the application externally, configure the EC2 Security Group inbound rule:

| Type | Protocol | Port | Source |
|---|---|---|---|
| Custom TCP | TCP | 5000 | Your IP address |

Then access the application:

```text
http://EC2-PUBLIC-IP:5000
```

For production, prefer placing Nginx in front of Gunicorn and exposing HTTP/HTTPS through ports 80/443 rather than publicly exposing port 5000.

## 20. Troubleshooting

### Check service status

```bash
sudo systemctl status python-calculator
```

### Check detailed service logs

```bash
sudo journalctl -u python-calculator -n 50 --no-pager
```

### Check whether port 5000 is in use

```bash
sudo ss -lntp | grep ':5000'
```

### Check application processes

```bash
ps -ef | grep gunicorn
```

### Restart the application

```bash
sudo systemctl restart python-calculator
```

### Validate the service file

```bash
sudo systemd-analyze verify /etc/systemd/system/python-calculator.service
```

## 21. Skills Practiced

- Linux package management using APT
- Python virtual environments
- Python dependency management using pip
- Flask application deployment
- Gunicorn application serving
- Linux background processes
- systemd service creation and