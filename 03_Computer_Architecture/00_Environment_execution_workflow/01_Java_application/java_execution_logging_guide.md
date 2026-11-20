# Java Application Execution & Management Guide (Linux / DevOps)

A hands-on guide covering the end-to-end lifecycle of Java application deployment and management on Linux servers.

Designed for **DevOps Engineers, Cloud Engineers, and Linux System Administrators**, this guide explains how Java applications are installed, compiled, executed, monitored, and managed in real-world Linux environments.

The practical exercises demonstrate foreground execution, background execution, `nohup`, log redirection, process monitoring, troubleshooting, and production-level service management using `systemd`.

---

## 📋 Table of Contents

- [1. Overview](#1-overview)
- [2. Understanding Java Execution Architecture](#2-understanding-java-execution-architecture)
- [3. Prerequisites & Java Installation](#3-prerequisites--java-installation)
- [4. Verify Java Environment](#4-verify-java-environment)
- [5. Create & Compile Java Application](#5-create--compile-java-application)
- [6. Execute Java Application](#6-execute-java-application)
  - [6.1 Foreground Execution](#61-foreground-execution)
  - [6.2 Background Execution](#62-background-execution)
  - [6.3 Background Execution with nohup](#63-background-execution-with-nohup)
- [7. Output Streams & Log Redirection](#7-output-streams--log-redirection)
- [8. Process Monitoring & Management](#8-process-monitoring--management)
- [9. Troubleshooting](#9-troubleshooting)
- [10. Production-Grade Setup with systemd](#10-production-grade-setup-with-systemd)
- [11. nohup vs systemd](#11-nohup-vs-systemd)
- [12. Summary of Linux Commands](#12-summary-of-linux-commands)

---

## 1. Overview

Understanding application execution and process management is one of the fundamental responsibilities of a Linux / DevOps Engineer.

In real-world environments, applications such as:

- Java Spring Boot applications
- Microservices
- Backend APIs
- Jenkins services
- Monitoring applications
- Enterprise applications

must run reliably on Linux servers.

A DevOps Engineer should understand:

1. How to install the required runtime.
2. How application code gets compiled.
3. How to execute an application.
4. How to run applications in the background.
5. How to redirect and monitor application logs.
6. How to monitor and troubleshoot application processes.
7. How to configure automatic service recovery.

Our objective is to understand this entire lifecycle through practical exercises.

---

## 2. Understanding Java Execution Architecture

Java follows a two-step execution model.

**Step 1: Compilation**

The Java compiler (`javac`) converts human-readable source code into platform-independent bytecode.

**Step 2: Execution**

The Java runtime (`java`) loads the bytecode into the JVM (Java Virtual Machine), which executes it.

### Java Execution Flow

```text
       Java Source Code
          HelloWorld.java
                |
                |
                v
       Java Compiler (javac)
                |
                |
                v
       Compiled Bytecode
          HelloWorld.class
                |
                |
                v
       Java Virtual Machine
               (JVM)
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

### Important Java Components

| Component | Description |
|---|---|
| JDK | Development Kit containing compiler and runtime tools |
| JRE | Runtime environment required to execute Java applications |
| JVM | Executes Java bytecode |
| javac | Compiles `.java` source files |
| java | Starts the JVM and executes the application |
| Bytecode | Compiled `.class` files |

---

## 3. Prerequisites & Java Installation

**Lab Environment:** Amazon Linux 2023 (AWS EC2).

Before deploying an application, we need to install the required software packages.

### Understanding Linux Package Management

Linux distributions provide package managers to install, update, remove, and manage software.

Amazon Linux 2023 uses the `dnf` package manager.

Some commonly used package management commands:

```bash
# Update installed packages
sudo dnf update -y

# Search for a Java package
sudo dnf search java-21-amazon-corretto

# Install Java 21 Development Kit
sudo dnf install java-21-amazon-corretto-devel -y

# Verify installed Java packages
rpm -qa | grep -i corretto

# Remove a package (example)
sudo dnf remove package-name
```

### Install Amazon Corretto JDK 21

```bash
sudo dnf install java-21-amazon-corretto-devel -y
```

**Why are we installing the `-devel` package?**

The development package provides the Java compiler (`javac`) along with the Java runtime required for this practical exercise.

---

## 4. Verify Java Environment

After installation, verify that Java and its compiler are available.

```bash
java -version

javac -version

which java

which javac
```

Expected output will show Java 21 and the corresponding compiler version.

### Check Java Installation Path

```bash
readlink -f $(which java)

readlink -f $(which javac)
```

These commands help identify the actual executable locations.

---

## 5. Create & Compile Java Application

Let's create a dedicated directory for our Java practice.

```bash
mkdir -p ~/java-practice

cd ~/java-practice
```

### Create HelloWorld.java

```bash
vi HelloWorld.java
```

Add the following code:

```java
public class HelloWorld {

    public static void main(String[] args) {

        System.out.println("Hello World!");

        System.out.println("Java application is running on Linux!");

    }
}
```

### Compile the Java Source Code

```bash
javac HelloWorld.java
```

Verify the generated bytecode:

```bash
ls -lh
```

Expected files:

```text
HelloWorld.java
HelloWorld.class
```

**Important:** The filename must match the public Java class name, including uppercase and lowercase characters.

For example:

```text
Public class: HelloWorld
File name:    HelloWorld.java
```

---

## 6. Execute Java Application

Now let's understand different ways of executing Java applications on Linux.

### 6.1 Foreground Execution

Execute the compiled Java application:

```bash
java HelloWorld
```

Output:

```text
Hello World!
Java application is running on Linux!
```

**What happens here?**

- The JVM starts.
- Java bytecode gets executed.
- Output is displayed directly in the terminal.
- The shell waits until the application exits.

This is useful for development, debugging, and testing.

### 6.2 Background Execution

In real-world environments, applications should not occupy an interactive terminal session.

We can use the Linux background operator `&`.

```bash
java HelloWorld &
```

Check the background job:

```bash
jobs -l
```

Check the running process:

```bash
ps -ef | grep HelloWorld
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
nohup java HelloWorld > ~/application.log 2>&1 &
```

Understand each component:

| Component | Purpose |
|---|---|
| `nohup` | Ignores terminal hangup |
| `java HelloWorld` | Starts the Java application |
| `>` | Redirects standard output |
| `application.log` | Stores application output |
| `2>&1` | Redirects standard error to standard output |
| `&` | Runs the command in the background |

Check the process:

```bash
pgrep -af HelloWorld
```

Check the application log:

```bash
cat ~/application.log
```

**Important:** `nohup` does not automatically restart an application if it crashes. Production services should generally be managed through `systemd` or another process supervisor.

---

## 7. Output Streams & Log Redirection

Linux provides three standard streams for process input and output.

| Stream | File Descriptor | Description |
|---|---:|---|
| stdin | 0 | Standard Input |
| stdout | 1 | Standard Output |
| stderr | 2 | Standard Error |

### Redirect Standard Output

```bash
java HelloWorld > /tmp/application.log
```

Only standard output is redirected.

### Redirect Standard Error

```bash
java HelloWorld 2> /tmp/application-error.log
```

Only error output is redirected.

### Redirect Both Output and Errors

```bash
java HelloWorld > /tmp/application.log 2>&1
```

Both standard output and standard error are written into the same log file.

### Append Logs Instead of Overwriting

```bash
java HelloWorld >> /tmp/application.log 2>&1
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

---

## 8. Process Monitoring & Management

A Linux / DevOps Engineer should know how to identify, monitor, and control application processes.

### Useful Process Commands

```bash
# Display running Java processes
pgrep -af java

# Search for a specific application
pgrep -af HelloWorld

# Display detailed process information
ps -ef | grep HelloWorld

# Display process resource utilization
top

# Display process tree
pstree -p
```

### Stop an Application

Find the process ID:

```bash
pgrep -af HelloWorld
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

---

## 9. Troubleshooting

Common problems encountered while running Java applications on Linux.

| Problem | Possible Reason | Troubleshooting |
|---|---|---|
| `java: command not found` | Java not installed or PATH issue | `which java` |
| `javac: command not found` | JDK compiler unavailable | `javac -version` |
| `Could not find or load main class` | Incorrect classpath or class name | Check `pwd` and `ls` |
| `ClassNotFoundException` | Required class missing | Check classpath and dependencies |
| Application exits immediately | Program completed or crashed | Inspect exit status and logs |
| Permission denied | File or directory permissions | `ls -l` and `namei -l` |
| Port already in use | Another process occupies the port | `ss -lntp` |
| Application not responding | Runtime or resource issue | Check logs, CPU, memory and threads |

### Useful Troubleshooting Commands

```bash
# Check Java processes
pgrep -af java

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
```

---

## 10. Production-Grade Setup with systemd

Manual execution and `nohup` are useful for learning and temporary processes.

However, production applications should be managed using Linux service management.

`systemd` provides:

- Automatic startup during system boot.
- Process supervision.
- Automatic restart after failures.
- Centralized service management.
- Integration with the Linux journal.

### Step 1: Create a Continuously Running Java Application

Create a file:

```bash
vi ApplicationMonitor.java
```

Add:

```java
public class ApplicationMonitor {

    public static void main(String[] args) throws InterruptedException {

        while (true) {

            System.out.println(
                "Java application is running on Linux - " +
                java.time.LocalDateTime.now()
            );

            Thread.sleep(10000);

        }
    }
}
```

This application generates a log message every 10 seconds.

Compile:

```bash
javac ApplicationMonitor.java
```

Test:

```bash
java ApplicationMonitor
```

Stop it using `Ctrl + C`.

### Step 2: Create a systemd Service

Create the service file:

```bash
sudo vi /etc/systemd/system/java-monitor.service
```

Add:

```ini
[Unit]
Description=Java Application Monitor
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/java-practice

ExecStart=/usr/bin/java -cp /home/ec2-user/java-practice ApplicationMonitor

Restart=on-failure
RestartSec=5

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

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

### Step 3: Reload systemd Configuration

Whenever a service file is created or modified, reload systemd.

```bash
sudo systemctl daemon-reload
```

### Step 4: Start the Application

```bash
sudo systemctl start java-monitor
```

### Step 5: Check Service Status

```bash
sudo systemctl status java-monitor
```

### Step 6: Enable Automatic Startup

```bash
sudo systemctl enable java-monitor
```

This configures the service to start automatically during system boot.

### Step 7: Monitor Application Logs

```bash
sudo journalctl -u java-monitor
```

Follow logs continuously:

```bash
sudo journalctl -u java-monitor -f
```

Display the latest 50 lines:

```bash
sudo journalctl -u java-monitor -n 50
```

### Step 8: Stop and Restart the Application

```bash
# Stop application
sudo systemctl stop java-monitor

# Restart application
sudo systemctl restart java-monitor

# Disable automatic startup
sudo systemctl disable java-monitor
```

### Step 9: Verify Application Process

```bash
pgrep -af ApplicationMonitor

ps -ef | grep ApplicationMonitor
```

---

## 11. nohup vs systemd

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

Use `systemd` for long-running Java applications and services that require reliable lifecycle management.

---

## 12. Summary of Linux Commands

| Command | Purpose |
|---|---|
| `dnf install` | Installs software packages |
| `java -version` | Checks Java runtime version |
| `javac -version` | Checks Java compiler version |
| `javac HelloWorld.java` | Compiles Java source code |
| `java HelloWorld` | Executes Java bytecode |
| `java HelloWorld &` | Executes application in background |
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

After completing this practical exercise, you should understand how a Java application moves from source code to a running Linux process.

You will have hands-on experience with:

- Linux package management.
- Java JDK and JVM fundamentals.
- Java compilation and execution.
- Foreground and background processes.
- `nohup` and shell job management.
- Linux standard output and error redirection.
- Application log monitoring.
- Process management and troubleshooting.
- Production-style service management using `systemd`.

**Next Step:** Apply the same concepts to a real Spring Boot application packaged as an executable JAR and deploy it on an AWS EC2 instance using `systemd`.

---

**Technology Stack:** Amazon Linux 2023 | AWS EC2 | Java 21 | Amazon Corretto | Linux | Bash | systemd | DevOps