# .NET Application Execution & Management Guide (Linux / DevOps)

A hands-on guide covering the end-to-end lifecycle of C# / .NET application deployment and management on Linux servers.

Designed for **DevOps Engineers, Cloud Engineers, and Linux System Administrators**, this guide explains how .NET applications are installed, built, executed, monitored, and managed in real-world Linux environments.

The practical exercises demonstrate .NET installation, C# application creation, compilation, publishing, foreground execution, background execution, `nohup`, NuGet dependency management, log redirection, process monitoring, troubleshooting, and production-level service management using `systemd`.

**Lab Environment:** AWS EC2 | Amazon Linux 2023 | .NET 10 | C#

---

## Table of Contents

1. Overview
2. Understanding .NET Execution Architecture
3. Prerequisites & .NET Installation
4. Verify .NET Environment
5. Create .NET Application
6. Build and Execute .NET Application
   - 6.1 Build Application
   - 6.2 Foreground Execution
   - 6.3 Background Execution
   - 6.4 Background Execution with nohup
7. NuGet & Dependency Management
8. Output Streams & Log Redirection
9. Process Monitoring & Management
10. Troubleshooting
11. Production-Grade Setup with systemd
12. nohup vs systemd
13. Summary of Linux Commands

---

## 1. Overview

Understanding application execution and process management is one of the fundamental responsibilities of a Linux / DevOps Engineer.

.NET is widely used for:

- Enterprise backend applications.
- Web applications and REST APIs.
- Microservices.
- Cloud-native applications.
- Windows and Linux services.
- Automation applications.
- Enterprise business applications.
- Containerized applications.

A DevOps Engineer should understand:

1. How to install .NET.
2. Difference between .NET SDK and runtime.
3. How C# applications are compiled.
4. How to build and publish applications.
5. How .NET manages dependencies.
6. How to execute applications on Linux.
7. How to execute applications in the background.
8. How to redirect and monitor application logs.
9. How to monitor and troubleshoot application processes.
10. How to configure automatic service recovery.
11. How to manage .NET applications using systemd.

Our objective is to understand this entire lifecycle through practical exercises.

---

## 2. Understanding .NET Execution Architecture

Unlike Python, C# applications normally go through a compilation process before execution.

The C# compiler converts source code into Intermediate Language (IL), which is stored in a .NET assembly.

The Common Language Runtime (CLR) manages application execution. The Just-In-Time (JIT) compiler converts IL into native machine code during execution.

### .NET Execution Flow

```text
           C# Source Code
             Program.cs
                 |
                 |
                 v
           C# Compiler
             (Roslyn)
                 |
                 |
                 v
       Intermediate Language
                (IL)
                 |
                 |
                 v
          .NET Assembly
             (.dll)
                 |
                 |
                 v
       Common Language Runtime
                (CLR)
                 |
                 |
                 v
          JIT Compiler
                 |
                 |
                 v
        Native Machine Code
                 |
                 |
                 v
          Linux Operating System
                 |
          +------+------+
          |             |
          v             v
      Foreground    Background
      Execution     Execution
          |             |
          v             v
       Terminal     Log Files /
       Output       systemd
```

### Important .NET Components

| Component | Description |
|---|---|
| C# | Programming language |
| .NET SDK | Tools required to develop and build applications |
| .NET Runtime | Executes compiled .NET applications |
| C# Compiler | Converts C# source code into IL |
| Roslyn | C# compiler platform |
| IL / CIL | Intermediate Language |
| CLR | Common Language Runtime |
| JIT | Converts IL into native machine code |
| NuGet | .NET package and dependency manager |
| `.csproj` | Project configuration file |
| `.dll` | Compiled .NET assembly |

**Important:** C# source code is not directly executed by Linux. The .NET build process generates assemblies, and the .NET runtime executes them.

---

## 3. Prerequisites & .NET Installation

**Lab Environment:** Amazon Linux 2023 (AWS EC2).

Before creating a .NET application, we need to install the required software packages.

### Understanding Linux Package Management

Amazon Linux 2023 uses the `dnf` package manager.

Check the operating system:

```bash
cat /etc/os-release
```

Update installed packages:

```bash
sudo dnf update -y
```

Search for available .NET packages:

```bash
sudo dnf search dotnet
```

Search specifically for the .NET 10 SDK:

```bash
sudo dnf search dotnet-sdk-10.0
```

### Install .NET 10 SDK

```bash
sudo dnf install dotnet-sdk-10.0 -y
```

**Why do we install the SDK?**

The SDK contains the tools required to:

- Create C# projects.
- Compile applications.
- Restore NuGet dependencies.
- Build applications.
- Publish applications.
- Execute applications during development.

The SDK also includes the corresponding runtime.

### Runtime-only installation

If a server only needs to execute an already-published application, installing the SDK may not be necessary.

For a regular .NET application:

```bash
sudo dnf install dotnet-runtime-10.0 -y
```

For an ASP.NET Core application:

```bash
sudo dnf install aspnetcore-runtime-10.0 -y
```

**Important:** Use the SDK on development/build machines. Production servers can use the appropriate runtime when deploying framework-dependent applications.

---

## 4. Verify .NET Environment

After installation, verify that .NET is available.

### Check .NET Version

```bash
dotnet --version
```

### Display Installed SDKs

```bash
dotnet --list-sdks
```

### Display Installed Runtimes

```bash
dotnet --list-runtimes
```

### Check .NET Information

```bash
dotnet --info
```

### Locate .NET Executable

```bash
which dotnet
```

Check the actual executable:

```bash
readlink -f $(which dotnet)
```

These commands help identify the installed SDK, runtime and executable locations.

---

## 5. Create .NET Application

Let's create a dedicated directory for our .NET practice.

### Step 1: Create Project Directory

```bash
mkdir -p ~/dotnet-practice

cd ~/dotnet-practice
```

### Step 2: Create a Console Application

```bash
dotnet new console -n HelloWorld
```

This command creates a new C# console application.

### Step 3: Navigate into the Project

```bash
cd HelloWorld
```

### Step 4: Understand Project Structure

```bash
ls -lh
```

Expected structure:

```text
HelloWorld/
|
|-- HelloWorld.csproj
|
|-- Program.cs
|
|-- obj/
```

Explanation:

| File / Directory | Purpose |
|---|---|
| Program.cs | Contains C# application code |
| HelloWorld.csproj | Defines project configuration |
| obj/ | Contains intermediate build files |

### Step 5: Understand Program.cs

Open the file:

```bash
vi Program.cs
```

Add the following code:

```csharp
Console.WriteLine("Hello World!");

Console.WriteLine(".NET application is running on Linux!");
```

### Understanding the C# Code

| Component | Purpose |
|---|---|
| `Console` | Provides console input and output |
| `WriteLine()` | Displays output and adds a new line |
| `Program.cs` | Main source code file |

### Step 6: Verify Application Files

```bash
ls -lh
```

**Important:** Unlike Python, a normal C# application must be built into .NET assemblies before deployment.

---

## 6. Build and Execute .NET Application

Now let's understand different ways of building and executing .NET applications on Linux.

### 6.1 Build Application

Navigate into the project directory:

```bash
cd ~/dotnet-practice/HelloWorld
```

Execute:

```bash
dotnet build
```

The build process:

1. Reads the project configuration.
2. Restores required NuGet dependencies.
3. Compiles C# source code.
4. Generates .NET assemblies.

Check the build output:

```bash
ls -lh bin/Debug/net10.0/
```

You should find files such as:

```text
HelloWorld.dll
HelloWorld.deps.json
HelloWorld.runtimeconfig.json
```

### 6.2 Foreground Execution

Execute the application:

```bash
dotnet run
```

Expected output:

```text
Hello World!
.NET application is running on Linux!
```

**What happens here?**

- The .NET SDK builds the application when required.
- The .NET runtime starts.
- The compiled application executes.
- Output is displayed directly in the terminal.
- The shell waits until the application exits.

This is useful for development, debugging and testing.

### Execute Without Building Again

```bash
dotnet run --no-build
```

This uses the existing build output.

### Execute the Compiled Assembly

```bash
dotnet bin/Debug/net10.0/HelloWorld.dll
```

This demonstrates how the .NET runtime executes an already-built assembly.

### 6.3 Background Execution

We can use the Linux background operator `&`.

```bash
dotnet bin/Debug/net10.0/HelloWorld.dll &
```

Check background jobs:

```bash
jobs -l
```

Check the process:

```bash
ps -ef | grep dotnet
```

**Important:** A simple Hello World application exits immediately. For meaningful background process practice, we will create a continuously running application.

### 6.4 Background Execution with nohup

`nohup` stands for No Hang Up.

It allows a process to ignore the hangup signal normally sent when the controlling terminal closes.

Execute:

```bash
nohup dotnet bin/Debug/net10.0/HelloWorld.dll > ~/application.log 2>&1 &
```

Understand each component:

| Component | Purpose |
|---|---|
| `nohup` | Ignores terminal hangup |
| `dotnet` | Starts the .NET runtime |
| `HelloWorld.dll` | Application assembly |
| `>` | Redirects standard output |
| `application.log` | Stores application output |
| `2>&1` | Redirects standard error to standard output |
| `&` | Runs the command in the background |

Check the process:

```bash
pgrep -af dotnet
```

Check application logs:

```bash
cat ~/application.log
```

**Important:** `nohup` does not automatically restart an application if it crashes. Production services should generally use systemd or another process supervisor.

---

## 7. NuGet & Dependency Management

One of the most important concepts in real-world .NET application deployment is dependency management.

### What is NuGet?

NuGet is the package manager used by .NET applications.

It helps developers install and manage external libraries required by their applications.

For example, an application might require:

- Logging libraries.
- Database connectivity libraries.
- Authentication libraries.
- JSON processing libraries.
- Monitoring libraries.

### Step 1: Understand the Project File

Open:

```bash
cat HelloWorld.csproj
```

Example:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net10.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
  </PropertyGroup>

</Project>
```

Important settings:

| Setting | Purpose |
|---|---|
| OutputType | Defines application output type |
| TargetFramework | Specifies the target .NET version |
| ImplicitUsings | Enables common namespace imports |
| Nullable | Enables nullable reference type analysis |

### Step 2: Restore Dependencies

```bash
dotnet restore
```

This restores the packages required by the project.

### Step 3: Add a NuGet Package

Example:

```bash
dotnet add package Newtonsoft.Json
```

This adds the package reference to the project file.

### Step 4: Verify Package References

```bash
dotnet list package
```

### Step 5: Build the Application

```bash
dotnet build
```

### Understanding Dependency Files

| File | Purpose |
|---|---|
| `.csproj` | Defines project and package references |
| `obj/project.assets.json` | Contains restored dependency information |
| `bin/` | Contains build output |
| NuGet cache | Stores downloaded packages |

**Important:** .NET does not use Python-style virtual environments by default. Project dependencies are managed through project files and NuGet, while SDK and runtime installations are managed separately.

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
dotnet HelloWorld.dll > /tmp/application.log
```

Only standard output is redirected.

### Redirect Standard Error

```bash
dotnet HelloWorld.dll 2> /tmp/application-error.log
```

Only error output is redirected.

### Redirect Both Output and Errors

```bash
dotnet HelloWorld.dll > /tmp/application.log 2>&1
```

### Append Logs Instead of Overwriting

```bash
dotnet HelloWorld.dll >> /tmp/application.log 2>&1
```

Difference:

- `>` overwrites an existing file.
- `>>` appends to an existing file.

### Monitor Logs in Real Time

```bash
tail -f /tmp/application.log
```

Display the last 50 lines:

```bash
tail -n 50 /tmp/application.log
```

### Search Application Errors

```bash
grep -i "error" /tmp/application.log
```

**Important:** .NET applications can use different logging providers. For our first exercise, we will understand Linux output redirection before introducing structured application logging.

---

## 9. Process Monitoring & Management

A Linux / DevOps Engineer should know how to identify, monitor and control .NET application processes.

### Useful Process Commands

Display running .NET processes:

```bash
pgrep -af dotnet
```

Search for a specific application:

```bash
pgrep -af HelloWorld
```

Display detailed process information:

```bash
ps -ef | grep dotnet
```

Display CPU and memory utilization:

```bash
top
```

Display memory information:

```bash
free -h
```

Display process tree:

```bash
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

**Important:** Prefer SIGTERM through `kill` over SIGKILL through `kill -9`. SIGTERM gives the application an opportunity to shut down gracefully.

### Additional Monitoring Commands

```bash
# Check running .NET processes
pgrep -af dotnet

# Check CPU and memory
top

# Check memory
free -h

# Check disk usage
df -Th

# Check listening ports
sudo ss -lntp

# Check application logs
tail -f application.log
```

---

## 10. Troubleshooting

Common problems encountered while running .NET applications on Linux.

| Problem | Possible Reason | Troubleshooting |
|---|---|---|
| `dotnet: command not found` | .NET not installed or PATH issue | `which dotnet` |
| SDK not found | SDK installation issue | `dotnet --list-sdks` |
| Runtime missing | Required runtime unavailable | `dotnet --list-runtimes` |
| Build failed | C# compilation errors | `dotnet build` |
| Package restore failed | NuGet connectivity or package issue | `dotnet restore` |
| Permission denied | File or directory permissions | `ls -l` |
| No such file or directory | Incorrect application path | `pwd` and `ls` |
| Address already in use | Another process occupies the port | `sudo ss -lntp` |
| Application exits immediately | Program completed or crashed | Inspect logs and exit status |
| Application not responding | Runtime or resource issue | Check logs, CPU and memory |
| systemd service fails | Incorrect service configuration | `systemctl status` |

### Useful Troubleshooting Commands

```bash
# Check .NET version
dotnet --version

# Check SDKs
dotnet --list-sdks

# Check runtimes
dotnet --list-runtimes

# Check .NET installation details
dotnet --info

# Check running processes
pgrep -af dotnet

# Check listening ports
sudo ss -lntp

# Check memory
free -h

# Check disk usage
df -Th

# Check application logs
tail -n 100 application.log

# Rebuild application
dotnet build

# Restore dependencies
dotnet restore
```

---

## 11. Production-Grade Setup with systemd

Manual execution and `nohup` are useful for learning and temporary processes.

However, production applications should generally be managed using Linux service management.

`systemd` provides:

- Automatic startup during system boot.
- Process supervision.
- Automatic restart after failures.
- Centralized service management.
- Integration with the Linux journal.
- Consistent application execution.

### Step 1: Create a Continuously Running C# Application

Navigate to the project directory:

```bash
cd ~/dotnet-practice
```

Create a worker-style console application:

```bash
dotnet new console -n DotNetMonitor
```

Navigate into the project:

```bash
cd DotNetMonitor
```

Open the application:

```bash
vi Program.cs
```

Add:

```csharp
using System;

while (true)
{
    Console.WriteLine(
        $" .NET application is running on Linux - {DateTime.Now}"
    );

    Thread.Sleep(10000);
}
```

This application generates a log message every 10 seconds.

### Step 2: Test the Application

```bash
dotnet run
```

Expected output:

```text
.NET application is running on Linux - ...
.NET application is running on Linux - ...
.NET application is running on Linux - ...
```

Stop the application using:

```text
Ctrl + C
```

### Step 3: Build the Application

```bash
dotnet build -c Release
```

### Step 4: Publish the Application

```bash
dotnet publish -c Release -o ./publish
```

Publishing prepares the application and its dependencies for deployment.

Check the published files:

```bash
ls -lh publish/
```

You should find files including:

```text
DotNetMonitor.dll
DotNetMonitor.deps.json
DotNetMonitor.runtimeconfig.json
```

This is a framework-dependent deployment, so the matching .NET runtime must be installed on the server.

### Step 5: Test the Published Application

```bash
dotnet ./publish/DotNetMonitor.dll
```

Stop it using `Ctrl + C`.

### Step 6: Create a systemd Service

Create the service file:

```bash
sudo vi /etc/systemd/system/dotnet-monitor.service
```

Add:

```ini
[Unit]
Description=.NET Application Monitor
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/home/ec2-user/dotnet-practice/DotNetMonitor/publish

ExecStart=/usr/bin/dotnet /home/ec2-user/dotnet-practice/DotNetMonitor/publish/DotNetMonitor.dll

Restart=on-failure
RestartSec=5

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

**Important:** This example assumes that `/usr/bin/dotnet` is the installed .NET executable and the application is published at the specified path. Verify both paths in your environment.

### Understanding the Service Configuration

| Directive | Purpose |
|---|---|
| `[Unit]` | Defines service metadata |
| `Description` | Describes the application |
| `After` | Controls startup ordering |
| `[Service]` | Defines application execution settings |
| `Type=simple` | Runs the application as a foreground process |
| `User` | Specifies the Linux user |
| `WorkingDirectory` | Defines application working directory |
| `ExecStart` | Command used to start the application |
| `Restart=on-failure` | Restarts the application after failure |
| `RestartSec=5` | Waits five seconds before restarting |
| `StandardOutput` | Sends output to the journal |
| `StandardError` | Sends errors to the journal |
| `[Install]` | Defines installation target |
| `WantedBy=multi-user.target` | Enables startup during normal multi-user boot |

### Step 7: Reload systemd Configuration

```bash
sudo systemctl daemon-reload
```

### Step 8: Start the Application

```bash
sudo systemctl start dotnet-monitor
```

### Step 9: Check Service Status

```bash
sudo systemctl status dotnet-monitor
```

### Step 10: Enable Automatic Startup

```bash
sudo systemctl enable dotnet-monitor
```

This configures the service to start automatically during system boot.

### Step 11: Monitor Application Logs

```bash
sudo journalctl -u dotnet-monitor
```

Follow logs continuously:

```bash
sudo journalctl -u dotnet-monitor -f
```

Display the latest 50 lines:

```bash
sudo journalctl -u dotnet-monitor -n 50
```

Display logs since the last boot:

```bash
sudo journalctl -u dotnet-monitor -b
```

### Step 12: Stop and Restart the Application

```bash
# Stop application
sudo systemctl stop dotnet-monitor

# Restart application
sudo systemctl restart dotnet-monitor

# Disable automatic startup
sudo systemctl disable dotnet-monitor
```

### Step 13: Verify Application Process

```bash
pgrep -af DotNetMonitor
```

```bash
ps -ef | grep dotnet
```

**Production consideration:** Use dedicated service accounts, grant minimum required permissions, protect application secrets, and configure log retention and rotation.

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

Use `nohup` for temporary background tasks, debugging and simple experiments.

Use `systemd` for long-running .NET applications and services that require reliable lifecycle management.

---

## 13. Summary of Linux Commands

| Command | Purpose |
|---|---|
| `dnf install` | Installs software packages |
| `dotnet --version` | Checks .NET version |
| `dotnet --info` | Displays .NET environment |
| `dotnet --list-sdks` | Displays installed SDKs |
| `dotnet --list-runtimes` | Displays installed runtimes |
| `dotnet new console` | Creates a console application |
| `dotnet restore` | Restores NuGet dependencies |
| `dotnet build` | Builds the application |
| `dotnet run` | Builds and executes the application |
| `dotnet run --no-build` | Executes using existing build output |
| `dotnet publish` | Prepares application for deployment |
| `dotnet add package` | Adds a NuGet package |
| `dotnet list package` | Displays project packages |
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

## Final Learning Outcome

After completing this practical exercise, you should understand how a C# / .NET application moves from source code to a running Linux process.

You will have hands-on experience with:

- Linux package management.
- .NET SDK and runtime fundamentals.
- C# application creation.
- C# compilation and IL fundamentals.
- .NET project structure.
- NuGet dependency management.
- Application building and publishing.
- Foreground and background processes.
- `nohup` and shell job management.
- Linux standard output and error redirection.
- Application log monitoring.
- Process management and troubleshooting.
- Production-style service management using `systemd`.

**Next Step:** Apply the same concepts to a real ASP.NET Core Web API, expose an HTTP endpoint, configure a security group, and deploy the application on an AWS EC2 instance using systemd.

---

**Technology Stack:** AWS EC2 | Amazon Linux 2023 | C# | .NET 10 | .NET SDK | NuGet | Linux | Bash | systemd | DevOps