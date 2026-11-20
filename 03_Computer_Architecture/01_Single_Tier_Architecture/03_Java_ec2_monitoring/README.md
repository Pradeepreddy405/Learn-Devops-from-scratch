# Java EC2 Monitoring Dashboard

A beginner-friendly Spring Boot project that displays basic Linux/EC2 system metrics in a browser.

## Features

- CPU usage
- Memory usage
- Root filesystem usage
- System uptime
- CPU load average
- JSON health/metrics API
- Browser dashboard that refreshes every 60 seconds
- Background execution using `nohup`
- Process management using Linux commands
- Automatic application startup using `systemd`
- Application logging to a dedicated log file

## Requirements

- Java 21
- Maven 3.8+
- Linux EC2 instance (Ubuntu or Amazon Linux 2023)
- AWS security group configured for the application port

## Project Structure

```text
java-ec2-monitoring/
├── README.md
├── logs/
│   └── .gitkeep
├── pom.xml
└── src/
    └── main/
        ├── java/com/devops/monitoring/
        │   ├── MonitoringApplication.java
        │   ├── controller/MonitoringController.java
        │   ├── model/SystemMetrics.java
        │   └── service/SystemMonitoringService.java
        └── resources/
            ├── application.properties
            ├── static/css/style.css
            ├── static/js/dashboard.js
            └── templates/dashboard.html
```

## 1. Build the Application

Navigate to the project root directory:

```bash
cd ~/Java_Monitoring_Application/03_Java_ec2_monitoring
```

Build the application using Maven:

```bash
mvn clean package
```

The executable JAR will be created at:

```text
target/ec2-monitoring-dashboard-1.0.0.jar
```

Verify the generated JAR:

```bash
ls -lh target/*.jar
```

## 2. Run the Application in the Foreground

Execute the JAR:

```bash
java -jar target/ec2-monitoring-dashboard-1.0.0.jar
```

The Spring Boot application will start in the current terminal.

Open the application:

```text
http://EC2_PUBLIC_IP:8080
```

Press `Ctrl + C` to stop the foreground application.

## 3. Run the Application in the Background Using nohup

Sometimes we want the application to continue running even after closing the terminal session.

Linux provides the `nohup` command for this purpose.

Create the log directory:

```bash
mkdir -p logs
```

Start the application in the background:

```bash
nohup java -jar target/ec2-monitoring-dashboard-1.0.0.jar > logs/application.log 2>&1 < /dev/null &
```

### Understanding the command

| Command | Purpose |
|---|---|
| `nohup` | Allows the process to continue after terminal logout |
| `java -jar` | Executes the Java application |
| `>` | Redirects standard output to a file |
| `2>&1` | Redirects error output to the same log file |
| `< /dev/null` | Prevents the process from reading terminal input |
| `&` | Runs the process in the background |

Display the background process ID:

```bash
echo $!
```

### 3.1 View Application Logs

```bash
tail -f logs/application.log
```

Display the last 50 log lines:

```bash
tail -n 50 logs/application.log
```

### 3.2 Find the Running Java Process

```bash
ps -ef | grep '[e]c2-monitoring-dashboard'
```

You can also check the process using:

```bash
pgrep -af ec2-monitoring-dashboard
```

### 3.3 Stop the Background Application Using kill

First, identify the application's PID:

```bash
ps -ef | grep '[e]c2-monitoring-dashboard'
```

Stop it gracefully:

```bash
kill <PID>
```

Verify whether the process has stopped:

```bash
ps -p <PID>
```

If the process does not stop after a reasonable wait, investigate it before considering a forced termination:

```bash
kill -9 <PID>
```

**Important:** `kill -9` forcefully terminates a process. Use normal `kill` first because it allows the application to shut down gracefully.

## 4. Create a systemd Service

Instead of manually starting the application every time, Linux provides `systemd` to manage services.

We can configure our Java application as a systemd service.

### 4.1 Create the Service File

Create a new service file:

```bash
sudo nano /etc/systemd/system/ec2-monitoring.service
```

Add the following configuration:

```ini
[Unit]
Description=Java EC2 Monitoring Dashboard
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/Java_Monitoring_Application/03_Java_ec2_monitoring

ExecStart=/usr/bin/java -jar /home/ubuntu/Java_Monitoring_Application/03_Java_ec2_monitoring/target/ec2-monitoring-dashboard-1.0.0.jar

Restart=always
RestartSec=10

StandardOutput=append:/home/ubuntu/Java_Monitoring_Application/03_Java_ec2_monitoring/logs/application.log
StandardError=append:/home/ubuntu/Java_Monitoring_Application/03_Java_ec2_monitoring/logs/application.log

[Install]
WantedBy=multi-user.target
```

Save the file:

- Press `Ctrl + O`
- Press `Enter`
- Press `Ctrl + X`

**Note:** This example uses the Ubuntu account and project path. Update `User`, `WorkingDirectory`, and JAR paths if your EC2 environment uses different values. Verify the Java executable path using `which java`.

### 4.2 Understand the Service File

| Configuration | Explanation |
|---|---|
| `[Unit]` | Defines service information and dependencies |
| `Description` | Human-readable service description |
| `After=network.target` | Starts after the network target |
| `[Service]` | Defines how the application runs |
| `Type=simple` | Runs the application as the main service process |
| `User=ubuntu` | Runs the application using the Ubuntu account |
| `WorkingDirectory` | Sets the application project directory |
| `ExecStart` | Command used to start the Java application |
| `Restart=always` | Restarts the application if it exits |
| `RestartSec=10` | Waits 10 seconds before restarting |
| `StandardOutput` | Stores standard output in the application log |
| `StandardError` | Stores error output in the application log |
| `[Install]` | Defines the service installation target |
| `WantedBy=multi-user.target` | Allows startup during normal system boot |

### 4.3 Reload systemd Configuration

After creating or modifying a service file, reload systemd:

```bash
sudo systemctl daemon-reload
```

This makes systemd read the updated service configuration.

### 4.4 Enable Automatic Startup

```bash
sudo systemctl enable ec2-monitoring
```

This configures the service to start automatically when the EC2 instance boots.

### 4.5 Start the Service

```bash
sudo systemctl start ec2-monitoring
```

### 4.6 Check Service Status

```bash
sudo systemctl status ec2-monitoring
```

Look for:

```text
Active: active (running)
```

This indicates that the service is running.

### 4.7 View Service Logs

View the application log file:

```bash
tail -f logs/application.log
```

Alternatively, view logs through systemd:

```bash
sudo journalctl -u ec2-monitoring
```

Follow logs continuously:

```bash
sudo journalctl -u ec2-monitoring -f
```

Show the latest 50 service log entries:

```bash
sudo journalctl -u ec2-monitoring -n 50
```

## 5. systemd Service Management Commands

| Operation | Command |
|---|---|
| Start service | `sudo systemctl start ec2-monitoring` |
| Stop service | `sudo systemctl stop ec2-monitoring` |
| Restart service | `sudo systemctl restart ec2-monitoring` |
| Check status | `sudo systemctl status ec2-monitoring` |
| Enable auto-start | `sudo systemctl enable ec2-monitoring` |
| Disable auto-start | `sudo systemctl disable ec2-monitoring` |
| Reload systemd | `sudo systemctl daemon-reload` |

## 6. Test Application After EC2 Reboot

Once the service is enabled, reboot the EC2 instance:

```bash
sudo reboot
```

Reconnect to the EC2 instance and check:

```bash
sudo systemctl status ec2-monitoring
```

If the service is active, automatic startup is working.

You can also verify the application locally:

```bash
curl http://localhost:8080/api/ping
```

## 7. API Endpoints

| Endpoint | Purpose |
|---|---|
| `/` | Monitoring dashboard |
| `/api/metrics` | Current system metrics as JSON |
| `/api/ping` | Simple application liveness response |

Test the endpoints:

```bash
curl http://localhost:8080/api/ping
curl http://localhost:8080/api/metrics
```

## 8. AWS Security Group Configuration

Make sure the EC2 security group allows inbound TCP port `8080` from your trusted IP address.

Open the application:

```text
http://EC2_PUBLIC_IP:8080
```

Avoid exposing the monitoring dashboard publicly without authentication and network restrictions.

## 9. Troubleshooting

### Check whether port 8080 is listening

```bash
sudo ss -ltnp | grep ':8080'
```

### Check Java processes

```bash
ps -ef | grep '[j]ava'
```

### Check systemd service logs

```bash
sudo journalctl -u ec2-monitoring -n 100
```

### Check application logs

```bash
tail -n 100 logs/application.log
```

### Check service configuration

```bash
sudo systemctl cat ec2-monitoring
```

### Common issues

| Problem | Possible reason |
|---|---|
| Unable to access JAR | Incorrect JAR path or missing build |
| Port already in use | Another process is using port 8080 |
| Service fails to start | Incorrect service configuration or Java path |
| Application keeps restarting | Application startup error or incorrect configuration |
| Browser cannot access application | Security group, firewall, or application binding issue |

## 10. Notes and Future Improvements

- OSHI is used to read operating-system metrics.
- CPU usage is sampled over a short interval, so the metrics endpoint may take a moment to respond.
- Filesystem usage is reported for the root mount point (`/`).
- This is a learning project, not a full production monitoring platform.
- For production, add authentication, TLS, access controls, alerting, and a metrics backend such as Prometheus.

## DevOps Concepts Practiced

Through this project, you will gain hands-on experience with:

- Java application packaging using Maven
- Executable JAR deployment
- Linux process management
- Background execution using `nohup`
- Process termination using `kill`
- Application log management
- Linux service management using `systemd`
- Automatic application startup after EC2 reboot
- AWS EC2 security groups
- Linux troubleshooting
- Basic server monitoring
