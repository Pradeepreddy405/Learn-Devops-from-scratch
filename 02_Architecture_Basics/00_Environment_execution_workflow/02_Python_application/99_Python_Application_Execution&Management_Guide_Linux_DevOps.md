# Python Application Execution & Management Guide (Linux / DevOps)

A hands-on guide covering the end-to-end lifecycle of Python application deployment and management on Linux servers.

Designed for **DevOps Engineers, Cloud Engineers, and Linux System Administrators**, this guide explains how Python applications are installed, executed, monitored, and managed in real-world Linux environments.

The practical exercises demonstrate foreground execution, background execution, `nohup`, virtual environments, dependency management, log redirection, process monitoring, troubleshooting, and production-level service management using `systemd`.

--- 

## 📋 Table of Contents

- [1. Overview](#1-overview)
- [2. Understanding Python Execution Architecture](#2-understanding-python-execution-architecture)
- [3. Prerequisites & Python Installation](#3-prerequisites--python-installation)
- [4. Verify Python Environment](#4-verify-python-environment)
- [5. Create Python Application](#5-create-python-application)
- [6. Execute Python Application](#6-execute-python-application)
  - [6.1 Foreground Execution](#61-foreground-execution)
  - [6.2 Background Execution](#62-background-execution)
  - [6.3 Background Execution with nohup](#63-background-execution-with-nohup)
- [7. Python Virtual Environments & Dependencies](#7-python-virtual-environments--dependencies)
- [8. Output Streams & Log Redirection](#8-output-streams--log-redirection)
- [9. Process Monitoring & Management](#9-process-monitoring--management)
- [10. Troubleshooting](#10-troubleshooting)
- [11. Production-Grade Setup with systemd](#11-production-grade-setup-with-systemd)
- [12. nohup vs systemd](#12-nohup-vs-systemd)
- [13. Summary of Linux Commands](#13-summary-of-linux-commands)

---

## 1. Overview

Understanding application execution and process management is one of the fundamental responsibilities of a Linux / DevOps Engineer.

In real-world environments, Python applications are widely used for:

- Backend APIs.
- Automation scripts.
- Infrastructure automation.
- AWS Lambda applications.
- Monitoring and alerting scripts.
- Data processing applications.
- Microservices.
- CI/CD automation.
- Configuration management.

A DevOps Engineer should understand:

1. How to install Python.
2. How Python applications are executed.
3. How Python handles dependencies.
4. How to create and manage virtual environments.
5. How to execute applications in the background.
6. How to redirect and monitor application logs.
7. How to monitor and troubleshoot Python processes.
8. How to configure automatic service recovery.
9. How to manage Python applications using systemd.

Our objective is to understand this entire lifecycle through practical exercises.

---

## 2. Understanding Python Execution Architecture

Unlike Java, Python generally does not require a separate manual compilation step before executing a `.py` file.

Python is commonly described as an interpreted language. In CPython, source code is compiled into bytecode internally, which is executed by the Python Virtual Machine.

### Python Execution Flow

```text
       Python Source Code
          HelloWorld.py
                |
                |
                v
       Python Interpreter
           (python3)
                |
                |
                v
       Python Bytecode
          (Internal)
                |
                |
                v
       Python Virtual Machine
                |
                |
                v
       Linux Operating System
                |
        +-------+--------+
        |                |
        v                v
   Foreground        Background
   Execution         Execution
        |                |
        v                v
   Terminal          Log Files
   Output            application.log
```

### Important Python Components

| Component | Description |
|---|---|
| Python | Programming language |
| Python Interpreter | Executes Python programs |
| CPython | Most commonly used Python implementation |
| python3 | Command used to execute Python applications |
| Bytecode | Intermediate instructions generated internally |
| pip | Python package installer |
| venv | Creates isolated Python environments |
| requirements.txt | Defines application dependencies |
| PVM | Python Virtual Machine executes bytecode |

**Important:** Python bytecode is not the same as Java bytecode. Python typically handles bytecode generation internally, so developers usually execute `.py` files directly.

---

## 3. Prerequisites & Python Installation

**Lab Environment:** Amazon Linux 2023 (AWS EC2).

Before deploying an application, we need to install the required software packages.

### Understanding Linux Package Management

Amazon Linux 2023 uses the `dnf` package manager.

Some commonly used package management commands:

```bash
# Update installed packages
sudo dnf update -y

# Search for Python packages
sudo dnf search python3

# Install Python 3
sudo dnf install python3 -y

# Install Python development tools if required
sudo dnf install python3-devel -y

# Verify installed Python packages
rpm -qa | grep -i python3

# Remove a package (example)
sudo dnf remove package-name
```

### Install Python 3

```bash
sudo dnf install python3 -y
```

Install pip if it is not already available:

```bash
sudo dnf install python3-pip -y
```

**Why do we need pip?**

`pip` is the package installer for Python. It helps install external libraries and dependencies required by Python applications.

Example:

```bash
python3 -m pip install requests
```

---

## 4. Verify Python Environment

After installation, verify that Python and pip are available.

```bash
# Check Python version
python3 --version

# Check pip version
python3 -m pip --version

# Locate Python executable
which python3

# Locate pip executable
which pip3
```

### Check Python Installation Path

```bash
readlink -f $(which python3)

readlink -f $(which pip3)
```

These commands help identify the actual executable locations.

### Execute Python Interactive Mode

```bash
python3
```

Expected output:

```text
Python 3.x.x
>>>
```

Try executing:

```python
print("Hello World!")
```

Exit the Python interpreter:

```python
exit()
```

Or press `Ctrl + D`.

---

## 5. Create Python Application

Let's create a dedicated directory for our Python practice.

```bash
mkdir -p ~/python-practice

cd ~/python-practice
```

### Create HelloWorld.py

```bash
vi HelloWorld.py
```

Add the following code:

```python
def main():

    print("Hello World!")

    print("Python application is running on Linux!")


if __name__ == "__main__":
    main()
```

### Understanding the Python Code

| Component | Purpose |
|---|---|
| `def main()` | Defines the main function |
| `print()` | Displays output |
| `if __name__ == "__main__"` | Executes main when the file is run directly |
| `main()` | Calls the main function |

### Verify the Python File

```bash
ls -lh
```

Expected file:

```text
HelloWorld.py
```

**Important:** Unlike Java, Python does not require a manual `javac`-style compilation command before normal execution.

### Optional: Compile Python Bytecode

Python can generate bytecode files using:

```bash
python3 -m py_compile HelloWorld.py
```

Check the generated files:

```bash
ls -R
```

You should find a `__pycache__` directory containing a `.pyc` file.

---

## 6. Execute Python Application

Now let's understand different ways of executing Python applications on Linux.

### 6.1 Foreground Execution

Execute the Python application:

```bash
python3 HelloWorld.py
```

Output:

```text
Hello World!
Python application is running on Linux!
```

**What happens here?**

- The Python interpreter starts.
- Python reads and executes the application.
- Output is displayed directly in the terminal.
- The shell waits until the application exits.

This is useful for development, debugging, and testing.

### 6.2 Background Execution

In real-world environments, applications should not occupy an interactive terminal session.

We can use the Linux background operator `&`.

```bash
python3 HelloWorld.py &
```

Check the background job:

```bash
jobs -l
```

Check the running process:

```bash
ps -ef | grep HelloWorld.py
```

**Understanding `&`:**

The `&` operator tells the shell to execute the command as a background job.

However, background execution alone does not guarantee that the process survives terminal logout.

For that requirement, we can use `nohup`.

### 6.3 Background Execution with nohup

`nohup` stands for No Hang Up.

It allows a process to ignore the hangup signal (`SIGHUP`) normally sent when the controlling terminal is closed.

Execute:

```bash
nohup python3 HelloWorld.py > ~/application.log 2>&1 &
```

Understand each component:

| Component | Purpose |
|---|---|
| `nohup` | Ignores terminal hangup |
| `python3 HelloWorld.py` | Starts the Python application |
| `>` | Redirects standard output |
| `application.log` | Stores application output |
| `2>&1` | Redirects standard error to standard output |
| `&` | Runs the command in the background |

Check the process:

```bash
pgrep -af HelloWorld.py
```

Check the application log:

```bash
cat ~/application.log
```

**Important:** A short-running Python application may finish before you check its process. Use a continuously running application when practicing background process management.

`nohup` does not automatically restart an application if it crashes. Production services should generally be managed through `systemd` or another process supervisor.

---

## 7. Python Virtual Environments & Dependencies

One of the most important concepts in real-world Python application deployment is virtual environment management.

### Why Do We Need Virtual Environments?

Imagine two Python applications:

- Application A requires Flask 2.x.
- Application B requires Flask 3.x.

Installing both dependencies globally can create version conflicts.

A virtual environment provides an isolated Python environment for each application.

### Step 1: Create a Virtual Environment

Navigate to your project directory:

```bash
cd ~/python-practice
```

Create a virtual environment:

```bash
python3 -m venv venv
```

### Step 2: Activate the Virtual Environment

```bash
source venv/bin/activate
```

You should now see the environment name in your terminal:

```text
(venv) [ec2-user@ip-xxx python-practice]$
```

### Step 3: Verify Python Environment

```bash
which python

python --version

python -m pip --version
```

The Python executable should point to your project's `venv/bin/python`.

### Step 4: Install Dependencies

Example:

```bash
python -m pip install requests
```

Verify the installed package:

```bash
python -m pip list
```

### Step 5: Generate requirements.txt

```bash
python -m pip freeze > requirements.txt
```

Check the file:

```bash
cat requirements.txt
```

Example:

```text
requests==2.x.x
```

The exact version depends on the installed package.

### Step 6: Install Dependencies from requirements.txt

For another environment or server:

```bash
python -m pip install -r requirements.txt
```

### Step 7: Deactivate the Virtual Environment

```bash
deactivate
```

**Important:** Do not install application dependencies into the system Python environment unnecessarily. Use a dedicated virtual environment for application deployments.

---

## 8. Output Streams & Log Redirection

Linux provides three standard streams for process input and output.

| Stream | File Descriptor | Description |
|---|---:|---|
| stdin | 0 | Standard Input |
| stdout | 1 | Standard Output |
| stderr | 2 | Standard Error |

### Redirect Standard Output

```bash
python3 HelloWorld.py > /tmp/application.log
```

Only standard output is redirected.

### Redirect Standard Error

```bash
python3 HelloWorld.py 2> /tmp/application-error.log
```

Only error output is redirected.

### Redirect Both Output and Errors

```bash
python3 HelloWorld.py > /tmp/application.log 2>&1
```

Both standard output and standard error are written into the same log file.

### Append Logs Instead of Overwriting

```bash
python3 HelloWorld.py >> /tmp/application.log 2>&1
```

Difference:

- `>` overwrites the existing file.
- `>>` appends to the existing file.

### Monitor Logs in Real Time

```bash
tail -f /tmp/application.log
```

For the last 50 lines:

```bash
tail -n 50 /tmp/application.log
```

### Python Output Buffering

Python may buffer output when stdout is redirected to a file.

For real-time log visibility, use unbuffered execution:

```bash
python3 -u HelloWorld.py
```

Or:

```bash
PYTHONUNBUFFERED=1 python3 HelloWorld.py
```

This is especially useful when running Python applications inside Docker containers or systemd services.

---

## 9. Process Monitoring & Management

A Linux / DevOps Engineer should know how to identify, monitor, and control Python application processes.

### Useful Process Commands

```bash
# Display running Python processes
pgrep -af python

# Search for a specific application
pgrep -af HelloWorld.py

# Display detailed process information
ps -ef | grep HelloWorld.py

# Display process resource utilization
top

# Display process tree
pstree -p
```

### Stop an Application

Find the process ID:

```bash
pgrep -af HelloWorld.py
```

Send a graceful termination signal:

```bash
kill <PID>
```

If the process does not terminate and you have investigated the issue:

```bash
kill -9 <PID>
```

**Important:** Prefer `kill` (SIGTERM) over `kill -9` (SIGKILL). SIGTERM gives an application an opportunity to shut down gracefully.

### Additional Log Monitoring Commands

```bash
# Follow logs continuously
tail -f application.log

# Search for errors
grep -i "error" application.log

# Search for exceptions
grep -i "exception" application.log

# Count error occurrences
grep -ic "error" application.log
```

### Monitor Python Process Resource Utilization

```bash
# Display process details
ps aux | grep python

# Display CPU and memory usage
top

# Display memory information
free -h

# Display open files for a process
sudo lsof -p <PID>
```

---

## 10. Troubleshooting

Common problems encountered while running Python applications on Linux.

| Problem | Possible Reason | Troubleshooting |
|---|---|---|
| `python3: command not found` | Python not installed or PATH issue | `which python3` |
| `ModuleNotFoundError` | Required package is missing | `python3 -m pip list` |
| `Permission denied` | File or directory permissions | `ls -l` and `namei -l` |
| `No such file or directory` | Incorrect application path | `pwd` and `ls` |
| `Address already in use` | Another process occupies the port | `ss -lntp` |
| `SyntaxError` | Invalid Python syntax | Review application code |
| `IndentationError` | Incorrect indentation | Check code indentation |
| Application exits immediately | Program completed or crashed | Inspect exit status and logs |
| `ModuleNotFoundError` in systemd | Virtual environment not configured | Check `ExecStart` path |
| Application not responding | Runtime or resource issue | Check logs, CPU, memory and processes |

### Useful Troubleshooting Commands

```bash
# Check Python version
python3 --version

# Check Python processes
pgrep -af python

# Check listening ports
sudo ss -lntp

# Check memory
free -h

# Check disk usage
df -Th

# Check CPU and memory utilization
top

# Check application logs
tail -n 100 application.log

# Check Python package dependencies
python3 -m pip list
```

---

## 11. Production-Grade Setup with systemd

Manual execution and `nohup` are useful for learning and temporary processes.

However, production applications should be managed using Linux service management.

`systemd` provides:

- Automatic startup during system boot.
- Process supervision.
- Automatic restart after failures.
- Centralized service management.
- Integration with the Linux journal.
- Consistent application execution.

### Step 1: Create a Continuously Running Python Application

Navigate to the project directory:

```bash
cd ~/python-practice
```

Create a file:

```bash
vi ApplicationMonitor.py
```

Add:

```python
import time
from datetime import datetime


def main():

    while True:

        print(
            f"Python application is running on Linux - {datetime.now()}",
            flush=True
        )

        time.sleep(10)


if __name__ == "__main__":
    main()
```

This application generates a log message every 10 seconds.

### Step 2: Test the Application

```bash
python3 ApplicationMonitor.py
```

Stop it using `Ctrl + C`.

### Step 3: Create a systemd Service

Create the service file:

```bash
sudo vi /etc/systemd/system/python-monitor.service
```

Add:

```ini
[Unit]
Description=Python Application Monitor
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/python-practice

ExecStart=/home/ec2-user/python-practice/venv/bin/python -u /home/ec2-user/python-practice/ApplicationMonitor.py

Restart=on-failure
RestartSec=5

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Important:** This example assumes the virtual environment exists at `/home/ec2-user/python-practice/venv`. If you are not using a virtual environment, replace the `ExecStart` interpreter path with the actual Python 3 executable path.

### Understanding the Service Configuration

| Directive | Purpose |
|---|---|
| `[Unit]` | Defines service metadata and dependencies |
| `Description` | Describes the application |
| `After` | Controls startup ordering |
| `[Service]` | Defines application execution settings |
| `Type=simple` | Runs the application as a foreground process |
| `User` | Specifies the Linux user |
| `WorkingDirectory` | Defines application working directory |
| `ExecStart` | Command used to start the application |
| `Restart=on-failure` | Restarts the application after failure |
| `RestartSec=5` | Waits five seconds before restarting |
| `StandardOutput` | Sends standard output to the journal |
| `StandardError` | Sends standard error to the journal |
| `[Install]` | Defines installation target |
| `WantedBy=multi-user.target` | Enables startup during normal multi-user boot |

### Step 4: Reload systemd Configuration

Whenever a service file is created or modified, reload systemd.

```bash
sudo systemctl daemon-reload
```

### Step 5: Start the Application

```bash
sudo systemctl start python-monitor
```

### Step 6: Check Service Status

```bash
sudo systemctl status python-monitor
```

### Step 7: Enable Automatic Startup

```bash
sudo systemctl enable python-monitor
```

This configures the service to start automatically during system boot.

### Step 8: Monitor Application Logs

```bash
sudo journalctl -u python-monitor
```

Follow logs continuously:

```bash
sudo journalctl -u python-monitor -f
```

Display the latest 50 lines:

```bash
sudo journalctl -u python-monitor -n 50
```

Display logs since the last boot:

```bash
sudo journalctl -u python-monitor -b
```

### Step 9: Stop and Restart the Application

```bash
# Stop application
sudo systemctl stop python-monitor

# Restart application
sudo systemctl restart python-monitor

# Disable automatic startup
sudo systemctl disable python-monitor
```

### Step 10: Verify Application Process

```bash
pgrep -af ApplicationMonitor.py

ps -ef | grep ApplicationMonitor.py
```

**Production consideration:** In real environments, run applications using dedicated service accounts, grant only the required filesystem permissions, protect credentials, and configure log retention and rotation.

---

## 12. nohup vs systemd

Understanding the difference between these two approaches is important for production support.

| Feature | nohup | systemd |
|---|---|---|
| Background execution | Yes | Yes |
| Survives terminal logout | Yes | Yes |
| Automatic restart after failure | No | Yes, if configured |
| Startup after reboot | No, not by itself | Yes, if enabled |
| Centralized logging | Manual redirection | journald integration |
| Service status | Process inspection | `systemctl status` |
| Production service management | Limited | Recommended |

**Real-world DevOps recommendation:**

Use `nohup` for temporary background tasks, debugging, and simple experiments.

Use `systemd` for long-running Python applications and services that require reliable lifecycle management.

---

## 13. Summary of Linux Commands

| Command | Purpose |
|---|---|
| `dnf install` | Installs software packages |
| `python3 --version` | Checks Python version |
| `python3 script.py` | Executes Python application |
| `python3 -m py_compile` | Compiles Python source into bytecode |
| `python3 -m pip install` | Installs Python packages |
| `python3 -m venv venv` | Creates virtual environment |
| `source venv/bin/activate` | Activates virtual environment |
| `deactivate` | Deactivates virtual environment |
| `pip freeze` | Lists installed package versions |
| `pip install -r requirements.txt` | Installs application dependencies |
| `python3 script.py &` | Executes application in background |
| `nohup` | Ignores terminal hangup |
| `> file 2>&1` | Redirects stdout and stderr |
| `>> file 2>&1` | Appends stdout and stderr |
| `tail -f` | Monitors logs continuously |
| `pgrep -af` | Finds matching processes |
| `ps -ef` | Displays running processes |
| `kill PID` | Gracefully terminates a process |
| `systemctl start` | Starts a service |
| `systemctl stop` | Stops a service |
| `systemctl restart` | Restarts a service |
| `systemctl enable` | Enables automatic boot startup |
| `systemctl status` | Checks service status |
| `journalctl -u` | Displays service logs |

---

## 🎯 Final Learning Outcome

After completing this practical exercise, you should understand how a Python application moves from source code to a running Linux process.

You will have hands-on experience with:

- Linux package management.
- Python interpreter fundamentals.
- Python application execution.
- Python bytecode fundamentals.
- Python virtual environments.
- Python dependency management using pip.
- Foreground and background processes.
- `nohup` and shell job management.
- Linux standard output and error redirection.
- Application log monitoring.
- Process management and troubleshooting.
- Production-style service management using `systemd`.

**Next Step:** Apply the same concepts to a real Python Flask or FastAPI application, package its dependencies using `requirements.txt`, and deploy it on an AWS EC2 instance using `systemd`.

---

**Technology Stack:** Amazon Linux 2023 | AWS EC2 | Python 3 | pip | venv | Linux | Bash | systemd | DevOps