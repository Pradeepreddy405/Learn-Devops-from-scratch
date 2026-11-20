# Node.js Installation & DevOps Hands-on Project

## Project Overview

**Project Name:** Node.js Process & Service Management  
**Platform:** AWS EC2  
**Operating System:** Amazon Linux 2023  
**Node.js Version:** 22.23.4  
**User:** ec2-user  
**Project Directory:** `/home/ec2-user/nodejs-practice`

### Project Objective

The objective of this project is to understand how to install Node.js on an AWS EC2 Linux server and manage Node.js applications using Linux process management, background execution, log redirection and systemd services.

## 1. Node.js Installation on Amazon Linux 2023

### Step 1.1 – Check operating system

```bash
cat /etc/os-release
```

Verify that the operating system is Amazon Linux 2023.

### Step 1.2 – Search for Node.js packages

```bash
sudo dnf search nodejs
```

**Purpose:**
- Search configured DNF repositories.
- Identify available Node.js packages.
- Discover different Node.js versions.
- Identify supporting packages such as npm and development libraries.

### Step 1.3 – Install Node.js 22

```bash
sudo dnf install nodejs22 -y
```

**Purpose:**

Installs the Node.js 22 runtime from the configured Amazon Linux repositories.

### Step 1.4 – Verify installation

Check Node.js:

```bash
node --version
```

Expected:

```text
v22.23.4
```

Check npm:

```bash
npm --version
```

Check executable locations:

```bash
which node
which npm
```

Check installed RPM package:

```bash
rpm -q nodejs22
```

## 2. Create Project Directory

```bash
mkdir -p /home/ec2-user/nodejs-practice
```

Navigate into the directory:

```bash
cd /home/ec2-user/nodejs-practice
```

Verify:

```bash
pwd
```

Expected:

```text
/home/ec2-user/nodejs-practice
```

## 3. Task 1 – Basic Node.js Application Execution

**Objective:** Understand how to execute a JavaScript file using Node.js from the Linux terminal.

### Step 3.1 – Create JavaScript file

```bash
vi taks_01.js
```

Enter:

```javascript
console.log("Hello MrCloud!");
console.log("Welcome to Node.js");
console.log("Learning DevOps with AWS");
```

Save and exit:

```text
Esc
:wq
Enter
```

### Step 3.2 – Execute application

```bash
node taks_01.js
```

Expected output:

```text
Hello MrCloud!
Welcome to Node.js
Learning DevOps with AWS
```

### Step 3.3 – Verify file

```bash
ls -l
```

**DevOps concepts learned:**
- Node.js runtime.
- JavaScript execution.
- Linux terminal execution.
- Application files.

## 4. Task 2 – Foreground Execution, Process Checking and Killing

**Objective:** Understand foreground execution and Linux process management.

### Step 4.1 – Create application

```bash
vi taks_02.js
```

Your original server information program:

```javascript
console.log("===== SERVER INFORMATION =====");

console.log("Operating System:", process.platform);
console.log("Architecture:", process.arch);
console.log("Node Version:", process.version);
console.log("Current Directory:", process.cwd());

console.log("===============================");
```

To practise process checking and killing, append the following lines to keep the application running:

```javascript
setInterval(() => {
    console.log("Application is running...");
}, 10000);
```

### Step 4.2 – Execute in foreground

```bash
node taks_02.js
```

The application occupies the terminal while running.

### Step 4.3 – Check process

Open another SSH terminal and execute:

```bash
ps -ef | grep node
```

Alternatively:

```bash
pgrep -af taks_02.js
```

### Step 4.4 – Kill process

Identify the PID:

```bash
pgrep -af taks_02.js
```

Execute:

```bash
kill <PID>
```

Replace `<PID>` with the actual process ID.

Alternatively, press `CTRL + C` in the foreground terminal.

### Step 4.5 – Verify

```bash
pgrep -af taks_02.js
```

**DevOps concepts learned:**
- Foreground processes.
- Process identification.
- PID.
- `ps` command.
- `pgrep` command.
- `kill` command.
- Application termination.

## 5. Task 3 – Background Execution, Process Checking and Killing

**Objective:** Run a Node.js application in the background without occupying the terminal.

### Step 5.1 – Create application

```bash
vi taks_03.js
```

Enter:

```javascript
console.log("Node.js application running in background");

setInterval(() => {
    console.log("Application is still running...");
}, 10000);
```

### Step 5.2 – Execute in background

```bash
node taks_03.js &
```

**Explanation:**

The `&` symbol runs the application in the background.

Example:

```text
[1] 12345
```

Here, `12345` is an example PID.

### Step 5.3 – Check running process

```bash
pgrep -af taks_03.js
```

Alternatively:

```bash
ps -ef | grep node
```

### Step 5.4 – Kill background process

```bash
kill <PID>
```

### Step 5.5 – Verify process termination

```bash
pgrep -af taks_03.js
```

**DevOps concepts learned:**
- Background execution.
- Linux process management.
- PID identification.
- Process termination.
- Foreground versus background execution.

## 6. Task 4 – Application Log Redirection

**Objective:** Execute a Node.js application in the background and redirect its output and errors into a log file.

### Step 6.1 – Create logs directory

```bash
mkdir -p logs
```

The directory will be:

```text
/home/ec2-user/nodejs-practice/logs
```

Verify:

```bash
ls -ld logs
```

### Step 6.2 – Create application

```bash
vi taks_04.js
```

Enter:

```javascript
console.log("Node.js application started successfully");

setInterval(() => {
    console.log(
        "Application is running:",
        new Date().toISOString()
    );
}, 5000);
```

### Step 6.3 – Execute with log redirection

```bash
node taks_04.js > logs/application.log 2>&1 &
```

**Command breakdown:**

| Symbol | Description |
|---|---|
| `node` | Node.js runtime |
| `taks_04.js` | Application file |
| `>` | Redirect standard output |
| `logs/application.log` | Log file destination |
| `2>` | Redirect standard error |
| `2>&1` | Redirect errors to the same destination as standard output |
| `&` | Execute in background |

### Step 6.4 – Check running process

```bash
pgrep -af taks_04.js
```

### Step 6.5 – Read application logs

```bash
cat logs/application.log
```

### Step 6.6 – Monitor logs continuously

```bash
tail -f logs/application.log
```

Press `CTRL + C` to exit log monitoring.

Note: This stops the `tail` command, not the Node.js application.

### Step 6.7 – Kill application

```bash
pgrep -af taks_04.js
```

Then:

```bash
kill <PID>
```

Verify:

```bash
pgrep -af taks_04.js
```

**DevOps concepts learned:**
- Application logging.
- Standard output (stdout).
- Standard error (stderr).
- Log redirection.
- Background execution.
- `tail` and `cat` commands.
- Application troubleshooting.

## 7. Task 5 – Configure Node.js Application Using systemd

**Objective:** Configure the Node.js application as a Linux system service.

In production environments, applications are commonly managed using systemd instead of manually starting processes.

### Step 7.1 – Create application

```bash
vi taks_05.js
```

Enter:

```javascript
console.log("Node.js systemd service started");

setInterval(() => {
    console.log(
        "Node.js service is running:",
        new Date().toISOString()
    );
}, 10000);
```

### Step 7.2 – Find Node.js executable path

```bash
which node
```

Example:

```text
/usr/bin/node
```

Use the actual path returned by your system.

### Step 7.3 – Create systemd service configuration

```bash
sudo vi /etc/systemd/system/nodejs-monitor.service
```

Enter:

```ini
[Unit]
Description=Node.js Monitoring Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/nodejs-practice
ExecStart=/usr/bin/node /home/ec2-user/nodejs-practice/taks_05.js
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

**Configuration explanation:**

| Configuration | Purpose |
|---|---|
| `[Unit]` | General service information |
| `Description` | Service description |
| `After` | Startup ordering |
| `[Service]` | Service execution configuration |
| `Type=simple` | Runs the process directly |
| `User` | Linux account used to run application |
| `WorkingDirectory` | Application directory |
| `ExecStart` | Command used to start application |
| `Restart=always` | Restart service when its process exits |
| `RestartSec=5` | Wait five seconds before restarting |
| `[Install]` | Boot-time enablement configuration |
| `WantedBy=multi-user.target` | Enables service for normal multi-user startup |

Important: Replace `/usr/bin/node` if your `which node` command returns another path.

### Step 7.4 – Reload systemd configuration

```bash
sudo systemctl daemon-reload
```

This reloads service configuration files.

### Step 7.5 – Start the service

```bash
sudo systemctl start nodejs-monitor
```

### Step 7.6 – Check service status

```bash
sudo systemctl status nodejs-monitor
```

Expected status:

```text
Active: active (running)
```

### Step 7.7 – Enable automatic startup

```bash
sudo systemctl enable nodejs-monitor
```

This enables the service to start automatically during system boot.

### Step 7.8 – View application logs

View all available logs:

```bash
sudo journalctl -u nodejs-monitor
```

View the latest 20 lines:

```bash
sudo journalctl -u nodejs-monitor -n 20
```

Monitor logs continuously:

```bash
sudo journalctl -u nodejs-monitor -f
```

Press `CTRL + C` to exit log monitoring without stopping the service.

### Step 7.9 – Restart service

```bash
sudo systemctl restart nodejs-monitor
```

### Step 7.10 – Stop service

```bash
sudo systemctl stop nodejs-monitor
```

### Step 7.11 – Disable automatic startup

```bash
sudo systemctl disable nodejs-monitor
```

### Step 7.12 – Verify service status

```bash
sudo systemctl status nodejs-monitor
```

**DevOps concepts learned:**
- systemd.
- Linux service management.
- Service configuration.
- Automatic application startup.
- Application restart policies.
- Journal logging.
- Service troubleshooting.

## 8. Final Project Structure

```text
nodejs-practice/
│
├── taks_01.js
├── taks_02.js
├── taks_03.js
├── taks_04.js
├── taks_05.js
│
└── logs/
    └── application.log
```

Systemd configuration is maintained separately:

```text
/etc/systemd/system/nodejs-monitor.service
```

## 9. Important Linux Commands Reference

| Command | Purpose |
|---|---|
| `node --version` | Check Node.js version |
| `npm --version` | Check npm version |
| `which node` | Find Node.js executable |
| `node filename.js` | Execute JavaScript application |
| `node filename.js &` | Run application in background |
| `ps -ef` | Display running processes |
| `pgrep -af process` | Search for process |
| `kill PID` | Terminate process |
| `tail -f logfile` | Monitor logs |
| `cat logfile` | Read log file |
| `systemctl start` | Start service |
| `systemctl stop` | Stop service |
| `systemctl restart` | Restart service |
| `systemctl status` | Check service status |
| `systemctl enable` | Enable startup at boot |
| `systemctl disable` | Disable startup at boot |
| `journalctl -u service` | View service logs |

## 10. Key DevOps Skills Demonstrated

After completing this project, you will have practical experience with:

1. Installing software packages using DNF.
2. Managing Node.js runtime environments.
3. Executing applications on Linux servers.
4. Understanding foreground and background processes.
5. Identifying and terminating Linux processes.
6. Redirecting application logs.
7. Monitoring application logs.
8. Creating systemd service configurations.
9. Managing application lifecycle using systemctl.
10. Troubleshooting Linux application services.



---

**Project Status:** Node.js installation and five-task DevOps practical project.

**Environment:** AWS EC2 – Amazon Linux 2023.

**Primary Learning Area:** Node.js application execution, Linux process management, logging and systemd service management.