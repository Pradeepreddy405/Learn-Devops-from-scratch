# Module 1: Ansible Fundamentals and Environment Setup

## Ansible Zero to Hero — Cloud & DevOps Engineering

Welcome to Module 1 of **Ansible Zero to Hero**.

In this module, you will learn Ansible from absolute fundamentals and build a working automation environment. You will understand how Ansible communicates with remote Linux servers, how configuration management works, and how to prepare your control node and managed nodes for real-world automation.

This module is designed for Linux Administrators, Cloud Engineers, DevOps Engineers, Site Reliability Engineers (SREs), and Platform Engineers.

---

## Table of Contents

1. [Learning Objectives](#1-learning-objectives)
2. [What Is Configuration Management?](#2-what-is-configuration-management)
3. [What Is Ansible?](#3-what-is-ansible)
4. [Why Do DevOps Engineers Use Ansible?](#4-why-do-devops-engineers-use-ansible)
5. [Ansible Architecture](#5-ansible-architecture)
6. [Control Node and Managed Nodes](#6-control-node-and-managed-nodes)
7. [Agentless Architecture](#7-agentless-architecture)
8. [How Ansible Works](#8-how-ansible-works)
9. [Push-Based Automation](#9-push-based-automation)
10. [Idempotency](#10-idempotency)
11. [Declarative Configuration Management](#11-declarative-configuration-management)
12. [Ansible vs Bash, Terraform, Puppet, and Chef](#12-ansible-vs-bash-terraform-puppet-and-chef)
13. [Ansible Installation](#13-ansible-installation)
14. [Verify the Ansible Installation](#14-verify-the-ansible-installation)
15. [Python and SSH Prerequisites](#15-python-and-ssh-prerequisites)
16. [SSH Key-Based Authentication](#16-ssh-key-based-authentication)
17. [Configure Sudo and Privilege Escalation](#17-configure-sudo-and-privilege-escalation)
18. [Ansible Configuration Files](#18-ansible-configuration-files)
19. [Understanding ansible.cfg](#19-understanding-ansiblecfg)
20. [Configuration Precedence](#20-configuration-precedence)
21. [Your First Ansible Command](#21-your-first-ansible-command)
22. [Hands-On Lab 1: Build an Ansible Environment](#22-hands-on-lab-1-build-an-ansible-environment)
23. [Troubleshooting Common Problems](#23-troubleshooting-common-problems)
24. [Security Best Practices](#24-security-best-practices)
25. [Interview Questions and Answers](#25-interview-questions-and-answers)
26. [Knowledge Assessment](#26-knowledge-assessment)
27. [Module Completion Checklist](#27-module-completion-checklist)
28. [References](#28-references)

---

# 1. Learning Objectives

By the end of this module, you should be able to:

- Explain configuration management and its importance.
- Understand what Ansible is and where it is used.
- Explain Ansible's architecture.
- Identify control nodes and managed nodes.
- Understand agentless automation and SSH communication.
- Explain push-based automation.
- Understand idempotency and declarative configuration.
- Compare Ansible with Bash, Terraform, Puppet, and Chef.
- Install Ansible on a Linux control node.
- Verify the installation and inspect the configuration.
- Configure SSH key-based authentication.
- Execute remote commands using Ansible.
- Understand sudo and privilege escalation.
- Create and configure an `ansible.cfg` file.
- Troubleshoot common connection and configuration problems.

## Prerequisites

You should have a basic understanding of:

- Linux commands.
- Linux users and groups.
- File permissions.
- SSH.
- IP addresses and ports.
- Basic networking.
- Terminal usage.

You do not need prior Ansible experience.

---

# 2. What Is Configuration Management?

## 2.1 Understand the Problem First

Imagine that you are a DevOps engineer responsible for managing 50 Linux servers.

Every server requires:

- Nginx installation.
- A specific application user.
- Standard directory permissions.
- Security configuration.
- Required software packages.
- Running application services.
- Consistent configuration files.

Without automation, you might connect to every server and perform these operations manually.

For example:

```bash
ssh user@server1
sudo apt-get install nginx -y

ssh user@server2
sudo apt-get install nginx -y

ssh user@server3
sudo apt-get install nginx -y
```

This approach becomes difficult as the number of servers increases.

It also creates opportunities for mistakes.

You might forget to install a package on one server, configure a different port on another, or leave a service stopped.

## 2.2 What Is Configuration Management?

**Configuration management is the process of defining, maintaining, and controlling the configuration of systems so that they operate consistently and as intended.**

Instead of manually configuring every server, you define the desired configuration and use automation to apply it.

For example, you can define that every web server must have:

- Nginx installed.
- Nginx enabled at boot.
- Nginx running.
- A standard configuration file.
- The correct application directories and permissions.

Ansible can apply these requirements to multiple servers.

## 2.3 Before and After Automation

### Without configuration management

```text
Engineer
   |
   +---- SSH ----> Server 1: Install Nginx manually
   |
   +---- SSH ----> Server 2: Install Nginx manually
   |
   +---- SSH ----> Server 3: Install Nginx manually
   |
   +---- SSH ----> Server 4: Install Nginx manually
```

### With Ansible

```text
                 Ansible Control Node
                          |
                    Ansible Playbook
                          |
             +------------+------------+
             |            |            |
             v            v            v
         Server 1     Server 2     Server 3
             |            |            |
             v            v            v
          Nginx        Nginx        Nginx
        installed     installed     installed
```

One automation workflow can configure multiple servers.

## 2.4 Benefits of Configuration Management

- Consistency across servers.
- Reduced repetitive manual work.
- Faster server configuration.
- Fewer configuration mistakes.
- Repeatable deployments.
- Easier auditing and troubleshooting.
- Better integration with CI/CD.
- Easier recovery and rebuilding of systems.

## 2.5 Real-World Example

Suppose an organization has 100 application servers.

The organization requires a new security configuration on all of them.

Instead of connecting to each server manually, an engineer can develop and test an Ansible playbook, validate the changes, and apply the configuration to the appropriate servers in controlled batches.

This makes the change repeatable and easier to review.

**Important:** Automation does not automatically guarantee security or correctness. Playbooks must be tested, reviewed, and executed with appropriate permissions.

---

# 3. What Is Ansible?

## 3.1 Definition

**Ansible is an open-source automation tool used to configure systems, deploy applications, orchestrate infrastructure, and automate IT operations.**

It commonly uses YAML files called playbooks to describe automation tasks.

Ansible can manage Linux systems over SSH and supports other connection methods for different platforms.

It is commonly used for:

- Configuration management.
- Linux administration.
- Application deployment.
- Infrastructure orchestration.
- Cloud automation.
- User and permission management.
- Security configuration.
- CI/CD automation.
- Operational maintenance.

## 3.2 Example

Suppose you need to install Nginx on three Linux servers.

You could create a playbook:

```yaml
---
- name: Install and start Nginx
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Ensure Nginx is running
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

This playbook describes the desired state of Nginx on the selected servers.

The `package` module installs Nginx if it is missing, while the `service` module ensures that the service is running and enabled.

The exact package name and service behavior can vary by operating system.

## 3.3 Why Is YAML Used?

YAML is a human-readable data serialization format.

Ansible playbooks commonly use YAML because it allows engineers to describe tasks and configuration in a structured format.

Example:

```yaml
application:
  name: payment-service
  port: 8080
  environment: production
```

You will learn YAML syntax and playbook structure in later modules.

## 3.4 Important Ansible Components

| Component | Description |
|---|---|
| Control node | Machine from which Ansible is executed |
| Managed node | Machine being managed by Ansible |
| Inventory | Defines the hosts and groups Ansible can target |
| Playbook | YAML file describing automation |
| Play | Maps a set of tasks to selected hosts |
| Task | An individual unit of work |
| Module | Performs a particular operation |
| Plugin | Extends Ansible's behavior |
| Role | Organizes reusable automation content |
| Collection | Distributes modules, plugins, roles, and related content |
| `ansible.cfg` | Configures Ansible behavior |
| Facts | Information gathered about managed systems |
| Handler | Task typically triggered by a notification from another task |

You will explore these components throughout the roadmap.

---

# 4. Why Do DevOps Engineers Use Ansible?

DevOps engineers often manage infrastructure that includes development, testing, staging, and production environments.

Manual configuration becomes inefficient and difficult to maintain at scale.

Ansible helps automate repetitive work.

## Common Use Cases

### 4.1 Linux Administration

Automate:

- User creation.
- Group management.
- Package installation.
- File permissions.
- Service management.
- Scheduled jobs.
- Configuration files.

### 4.2 Application Deployment

Automate:

- Application artifact deployment.
- Configuration file generation.
- Runtime installation.
- Service startup.
- Health checks.
- Controlled updates.

### 4.3 AWS Cloud Operations

Ansible can:

- Discover EC2 instances using dynamic inventory.
- Configure operating systems on EC2 instances.
- Install application dependencies.
- Deploy applications.
- Manage selected AWS resources through supported collections.

### 4.4 CI/CD Integration

A pipeline can execute Ansible after an application artifact has been built and validated.

Example:

```text
Developer
    |
    v
GitHub
    |
    v
CI Pipeline
    |
    v
Build and Test
    |
    v
Ansible Deployment
    |
    v
Application Servers
    |
    v
Health Checks
```

### 4.5 Security Automation

Ansible can automate:

- Standard user access policies.
- SSH configuration.
- Firewall rules.
- File permissions.
- Security baseline configuration.
- Compliance checks.

Security automation must be carefully tested because incorrect changes can interrupt access or application availability.

---

# 5. Ansible Architecture

## 5.1 High-Level Architecture

Ansible uses a control node to coordinate automation across managed nodes.

```text
                  ENGINEER
                      |
                      v
              ANSIBLE CONTROL NODE
              --------------------
              | Inventory        |
              | Playbooks         |
              | Modules           |
              | Configuration     |
              | SSH Credentials   |
              --------------------
                      |
                  SSH / SFTP
                      |
          +-----------+-----------+
          |           |           |
          v           v           v
      MANAGED 1   MANAGED 2   MANAGED 3
      ----------  ----------  ----------
      Linux       Linux       Linux
      Server      Server      Server
```

For many Linux targets, Ansible connects over SSH, transfers the required execution code, runs it remotely, and collects the results.

The exact execution and file-transfer behavior depends on the connection configuration and the module being used.

## 5.2 How the Components Work Together

### Engineer

Writes the automation requirements and executes the playbook.

### Control Node

Runs Ansible and coordinates the automation process.

### Inventory

Specifies which machines Ansible should manage.

### Playbook

Defines the tasks to execute.

### Module

Performs an operation, such as installing a package or managing a service.

### Managed Node

Receives and executes the required operations.

### Result

Ansible reports whether each task succeeded, changed the system, failed, or was skipped.

## 5.3 Example Execution Flow

Suppose you run:

```bash
ansible webservers -i inventory.ini -m ansible.builtin.ping
```

The general workflow is:

1. Ansible reads the inventory.
2. It selects the hosts in the `webservers` group.
3. It determines the connection settings.
4. It attempts to connect to the selected hosts.
5. It executes the ping module.
6. It collects the results.
7. It displays the status for each host.

The Ansible ping module tests Ansible connectivity and remote Python execution. It is not an ICMP network ping.

---

# 6. Control Node and Managed Nodes

## 6.1 What Is a Control Node?

A control node is the machine from which Ansible commands and playbooks are executed.

It may be:

- A Linux virtual machine.
- An AWS EC2 instance.
- A dedicated automation server.
- A developer's Linux workstation.
- A CI/CD runner.

For this learning roadmap, use a Linux machine as the control node.

The control node needs a supported Python environment for Ansible and the required connectivity to the managed nodes.

## 6.2 What Is a Managed Node?

A managed node is a machine that Ansible configures or operates.

Examples include:

- Linux application servers.
- Web servers.
- Database servers.
- AWS EC2 instances.
- Virtual machines.
- Other supported managed systems.

For typical Linux SSH automation, the managed node generally needs SSH access and a compatible Python interpreter.

The control node and managed nodes do not need to be the same machine.

## 6.3 Example Environment

| Machine | Role | Example address | Purpose |
|---|---|---|---|
| ansible-control | Control node | 192.168.1.100 | Runs Ansible |
| web01 | Managed node | 192.168.1.101 | Web server |
| app01 | Managed node | 192.168.1.102 | Application server |

The addresses are examples. Replace them with addresses from your own environment.

## 6.4 Recommended Lab Setup

For beginners:

- One Ubuntu control node.
- Two Ubuntu managed nodes.
- SSH access from the control node to both managed nodes.
- A non-root automation user.
- Python 3 on the control node.
- A compatible Python interpreter on each managed node.

You can build this lab using local virtual machines or AWS EC2 instances.

For AWS labs, account for instance charges, storage costs, and network transfer costs where applicable.

---

# 7. Agentless Architecture

## 7.1 What Does Agentless Mean?

Ansible is commonly described as agentless because standard Linux SSH automation does not require a continuously running Ansible agent on each managed host.

Instead, Ansible initiates connections from the control node when automation runs.

For typical Linux automation, it uses SSH to communicate with the managed system.

## 7.2 Traditional Agent-Based Approach

In an agent-based architecture:

```text
Management Server
        |
        v
     Agent
        |
        v
   Managed Server
```

Depending on the tool, an agent may need to be installed, configured, updated, and maintained.

## 7.3 Typical Ansible Linux Approach

```text
Ansible Control Node
        |
        | SSH
        v
Linux Managed Node
        |
        v
Execute Required Task
```

No persistent Ansible agent is normally required for this workflow.

However, the managed node still needs the appropriate operating system services, permissions, interpreters, and other prerequisites.

## 7.4 Advantages

- Fewer persistent components to manage.
- Convenient remote administration.
- No continuously running Ansible agent required for ordinary SSH-based Linux management.
- Easy integration with existing SSH access controls.
- Suitable for temporary cloud instances.

## 7.5 Limitations

Agentless does not mean dependency-free.

For typical Linux SSH automation, you still need:

- Network connectivity.
- An SSH service on the managed node.
- Valid authentication.
- Appropriate permissions.
- A compatible Python interpreter for most modules.

Some modules and connection methods have different requirements.

---

# 8. How Ansible Works

Understanding the execution workflow will help you troubleshoot automation later.

## Step 1: Define the Inventory

Example `inventory.ini`:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[webservers:vars]
ansible_user=automation
```

The inventory identifies the servers and specifies the SSH username for the group.

## Step 2: Create a Playbook

Example `site.yml`:

```yaml
---
- name: Check web server connectivity
  hosts: webservers
  gather_facts: false

  tasks:
    - name: Verify Ansible connectivity
      ansible.builtin.ping:
```

## Step 3: Execute the Playbook

```bash
ansible-playbook -i inventory.ini site.yml
```

## Step 4: Ansible Processes the Configuration

Ansible reads:

- Configuration settings.
- Inventory information.
- The playbook.
- Applicable variables.
- Connection details.

## Step 5: Connect to the Managed Nodes

For ordinary Linux SSH automation, Ansible establishes SSH connections to the selected servers.

## Step 6: Execute Tasks

Ansible runs the required modules on the managed nodes.

## Step 7: Collect Results

Ansible reports the task status for each host.

Example output:

```text
PLAY [Check web server connectivity] ************************

TASK [Verify Ansible connectivity] ***************************
ok: [web01]
ok: [web02]

PLAY RECAP ***************************************************
web01 : ok=1 changed=0 unreachable=0 failed=0
web02 : ok=1 changed=0 unreachable=0 failed=0
```

This is illustrative output. Actual output depends on the Ansible version and execution environment.

---

# 9. Push-Based Automation

## 9.1 What Is Push-Based Automation?

In a push-based automation model, the control system initiates the operation and sends the required configuration or commands to the target systems.

Ansible commonly uses this model for SSH-based Linux automation.

The engineer starts the automation from the control node.

## 9.2 Example

```text
Engineer
   |
   v
Ansible Control Node
   |
   +------ SSH ------> Web Server 1
   |
   +------ SSH ------> Web Server 2
   |
   +------ SSH ------> Web Server 3
```

The control node initiates the automation.

## 9.3 Push-Based vs Pull-Based

| Feature | Push-based | Pull-based |
|---|---|---|
| Initiator | Central controller | Managed system or agent |
| Typical workflow | Controller sends changes | Managed system retrieves configuration |
| Ansible SSH model | Commonly push-based | Not the usual SSH workflow |
| Operational consideration | Controller must reach targets | Targets must reach the configuration source |
| Example consideration | Run a playbook against servers | A system periodically retrieves desired configuration |

The distinction depends on the actual tool and deployment model. Do not assume every configuration management product supports only one approach.

## 9.4 When Is Push-Based Automation Useful?

- One-time server configuration.
- Application deployments.
- Scheduled administrative tasks.
- CI/CD-driven deployments.
- Controlled configuration updates.
- Managing cloud instances from a central automation environment.

---

# 10. Idempotency

## 10.1 What Is Idempotency?

**Idempotency means that repeatedly applying an operation produces the same intended state after the first successful application.**

This is one of the most important concepts in Ansible.

Suppose a server must have Nginx installed.

The desired state is:

```text
Nginx must be installed.
```

If Nginx is missing, Ansible installs it.

If Nginx is already installed, Ansible normally leaves it installed without reinstalling it unnecessarily.

## 10.2 Example of an Idempotent Task

```yaml
---
- name: Ensure Nginx is installed
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

The `state: present` parameter expresses the desired package state.

On a supported package-managed system, rerunning the playbook should not repeatedly reinstall the package when it is already present.

## 10.3 Example of a Non-Idempotent Approach

```yaml
- name: Append a message to a file
  ansible.builtin.shell: "echo 'Ansible configured this server' >> /tmp/ansible-demo.txt"
```

Every execution appends another line.

Running it repeatedly produces:

```text
Ansible configured this server
Ansible configured this server
Ansible configured this server
```

This task is not idempotent because its repeated execution continues changing the file.

A better approach for managing a particular line is:

```yaml
- name: Ensure the message exists in the file
  ansible.builtin.lineinfile:
    path: /tmp/ansible-demo.txt
    line: Ansible configured this server
    create: true
```

This task manages the presence of the specified line rather than blindly appending it on every run.

## 10.4 Understanding Ansible Results

Ansible commonly reports the following task states:

| State | Meaning |
|---|---|
| `ok` | The task completed without changing the managed state |
| `changed` | The task changed the managed state or reported a change |
| `failed` | The task failed |
| `unreachable` | Ansible could not reach the host |
| `skipped` | The task was not executed |

The exact result depends on the module and its behavior.

## 10.5 Why Idempotency Matters

Idempotency helps with:

- Repeated deployments.
- Recovery after partial failures.
- Consistent server configuration.
- Reduced unnecessary changes.
- Configuration drift remediation.
- Safer automation.

**Important:** Not every Ansible task is automatically idempotent. Shell commands, custom scripts, and some modules require careful design.

---

# 11. Declarative Configuration Management

## 11.1 What Is Declarative Configuration?

Declarative configuration describes the desired result rather than specifying every step required to produce it.

For example:

```text
Desired state:
Nginx must be installed and running.
```

Ansible tasks can express this requirement.

```yaml
---
- name: Ensure Nginx is available
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present

    - name: Ensure Nginx is running
      ansible.builtin.service:
        name: nginx
        state: started
```

Ansible uses the modules and system state to determine what action is required.

## 11.2 Declarative vs Imperative

### Imperative approach

You describe the commands or steps to perform.

Example:

```bash
sudo apt-get update
sudo apt-get install -y nginx
sudo systemctl start nginx
```

These commands describe operations to execute.

### Declarative approach

You describe the desired state.

Example:

```yaml
- name: Ensure Nginx is installed
  ansible.builtin.package:
    name: nginx
    state: present
```

The module checks the current state and performs the required action.

## 11.3 Comparison

| Feature | Imperative | Declarative |
|---|---|---|
| Primary focus | Operations to execute | Desired state |
| Example | Run installation commands | Ensure a package is installed |
| Repeated execution | Depends on the commands | Often naturally repeatable with suitable modules |
| State awareness | Must be implemented or handled by commands | Often built into the module |
| Ansible example | `ansible.builtin.command` | `ansible.builtin.package` |

Ansible supports both imperative command execution and declarative state management. The choice of module and task design determines how reliably repeated execution behaves.

---

# 12. Ansible vs Bash, Terraform, Puppet, and Chef

Understanding the differences helps you select the right tool for the job.

## 12.1 Ansible vs Bash

| Feature | Ansible | Bash |
|---|---|---|
| Primary purpose | Automation and configuration management | Shell scripting and command execution |
| Syntax | Primarily YAML for playbooks | Shell commands and scripting syntax |
| Remote execution | Built-in inventory and connection mechanisms | Usually requires SSH or other tools |
| Idempotency | Many modules support desired-state management | Must generally be implemented in the script |
| Reusability | Roles, collections, and playbooks | Functions, scripts, and libraries |
| Reporting | Structured task results | Depends on script implementation |
| Best use | Repeatable infrastructure automation | Shell tasks and custom command workflows |

Bash is still valuable. Ansible does not eliminate the need to understand Linux commands and shell behavior.

## 12.2 Ansible vs Terraform

| Feature | Ansible | Terraform |
|---|---|---|
| Primary focus | Configuration management and operational automation | Infrastructure provisioning and lifecycle management |
| Common use | Configure servers and deploy applications | Create networks, virtual machines, databases, and cloud resources |
| Language | YAML-based playbooks | HCL |
| State management | Does not use Terraform-style resource state as its primary model | Uses state to track managed infrastructure resources |
| Common AWS workflow | Configure EC2 instances and applications | Provision EC2 instances and related infrastructure |

### Example Combined Workflow

```text
Terraform
   |
   v
Create VPC, Subnets, Security Groups, and EC2
   |
   v
Ansible
   |
   v
Configure Linux
   |
   v
Install Dependencies
   |
   v
Deploy Application
   |
   v
Validate Application
```

Terraform and Ansible complement each other.

Ansible can also manage selected infrastructure resources, and Terraform can provision systems that require configuration management afterward.

## 12.3 Ansible vs Puppet

| Feature | Ansible | Puppet |
|---|---|---|
| Common model | Push-based SSH automation | Commonly agent-based |
| Configuration style | YAML playbooks | Puppet language and manifests |
| Persistent agent | Not normally required for standard SSH Linux management | Commonly uses an agent |
| Typical strength | Flexible operational automation | Continuous configuration enforcement in established deployments |

Actual architectures depend on the product version and deployment model.

## 12.4 Ansible vs Chef

| Feature | Ansible | Chef |
|---|---|---|
| Configuration style | YAML playbooks | Ruby-based recipes and resources |
| Common execution model | Push-based SSH automation | Commonly client-server with Chef Infra Client |
| Agent requirement | Not normally required for standard SSH automation | Commonly requires a client agent |
| Learning approach | YAML and Ansible modules | Chef resources, recipes, and Ruby concepts |

### Which Should a Cloud and DevOps Engineer Learn?

A practical combination is:

1. Linux administration.
2. Bash scripting.
3. Ansible.
4. Terraform.
5. Docker and Kubernetes.
6. CI/CD tools.
7. Monitoring and observability.

The tools solve different problems. Understanding how to combine them is more valuable than treating them as interchangeable.

---

# 13. Ansible Installation

For this lab, we will use Ubuntu as the control node.

Installation commands can differ by operating system, package repository, and Ansible release.

Consult the official installation documentation for supported methods and versions.

Official documentation: [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

## 13.1 Update the Package Index

```bash
sudo apt update
```

This refreshes the local package index.

## 13.2 Install Python and pip

```bash
sudo apt install -y python3 python3-pip python3-venv
```

Verify Python:

```bash
python3 --version
```

Verify pip:

```bash
python3 -m pip --version
```

## 13.3 Install Ansible

### Option A: Ubuntu Package Repository

```bash
sudo apt install -y ansible
```

This is a convenient beginner-friendly approach. The version depends on the Ubuntu release and configured repositories.

### Option B: Isolated Python Virtual Environment

An isolated virtual environment can help manage Python dependencies without changing the system Python environment.

Create a directory:

```bash
mkdir -p ~/ansible-lab
cd ~/ansible-lab
```

Create a virtual environment:

```bash
python3 -m venv .venv
```

Activate it:

```bash
source .venv/bin/activate
```

Upgrade pip:

```bash
python -m pip install --upgrade pip
```

Install the Ansible community package:

```bash
python -m pip install ansible
```

Verify the installation:

```bash
ansible --version
```

When you use this method, activate the virtual environment before running Ansible:

```bash
source ~/ansible-lab/.venv/bin/activate
```

For repeatable environments, record and pin the versions of the required dependencies.

**Recommendation:** Choose one installation method for your lab and document it. Avoid mixing system packages and Python package installations without understanding which executable your shell is using.

---

# 14. Verify the Ansible Installation

After installation, execute the following commands.

## 14.1 Check the Version

```bash
ansible --version
```

The output typically includes:

- Ansible version.
- Python version.
- Configuration file location, if applicable.
- Module search paths.
- Collection locations.
- Python executable information.

## 14.2 Locate the Executable

```bash
which ansible
```

For more detail:

```bash
command -v ansible
```

## 14.3 Inspect Configuration

```bash
ansible-config list
```

Display the effective configuration values:

```bash
ansible-config dump
```

Inspect the configuration file currently selected by Ansible:

```bash
ansible-config view
```

The last command displays configuration file content when a configuration file is selected. It does not create one.

## 14.4 Inspect Installed Packages

For Ubuntu package installation:

```bash
apt list --installed 2>/dev/null | grep -i ansible
```

For a Python virtual environment:

```bash
python -m pip show ansible
```

---

# 15. Python and SSH Prerequisites

## 15.1 Python Requirements

Ansible itself requires Python on the control node.

For ordinary Linux SSH automation, most modules also require a compatible Python interpreter on the managed node.

Some operations and modules have different requirements, so consult the documentation for the relevant module and connection type.

Check Python on the control node:

```bash
python3 --version
```

Check Python on a managed node:

```bash
ssh automation@192.168.1.101 'python3 --version'
```

Replace the username and IP address with your actual lab values.

If Python is missing on a managed node, install it using an appropriate bootstrap method before running modules that require it.

## 15.2 SSH Requirements

For standard Linux SSH automation, the control node must be able to connect to the managed node.

Check SSH client availability:

```bash
ssh -V
```

Check the managed node's SSH service:

```bash
sudo systemctl status ssh
```

On some Linux distributions, the service is named `sshd` instead of `ssh`.

If the service is not installed, the package name and installation procedure depend on the operating system.

## 15.3 Network Connectivity

Verify that:

- The managed node has a reachable IP address or hostname.
- The correct SSH port is accessible.
- Firewalls and security groups allow the connection.
- Routing between the machines works.
- The SSH service is running.

The default SSH port is TCP port 22, but your environment may use a different port.

---

# 16. SSH Key-Based Authentication

## 16.1 What Is SSH?

SSH stands for Secure Shell.

It provides an encrypted connection for remote administration and command execution.

Example:

```bash
ssh automation@192.168.1.101
```

This command attempts to connect to the remote machine using the `automation` account.

## 16.2 Password Authentication vs Key-Based Authentication

### Password authentication

The user authenticates with a password.

### Key-based authentication

The user authenticates using a cryptographic key pair.

The key pair contains:

- A private key that must remain secret.
- A public key that can be installed on the managed node.

The private key stays on the control node and should not be copied to the managed nodes.

## 16.3 Generate an SSH Key Pair

On the control node:

```bash
ssh-keygen -t ed25519 -C "ansible-control"
```

Follow the prompts.

The default private key path is commonly:

```text
~/.ssh/id_ed25519
```

The public key path is commonly:

```text
~/.ssh/id_ed25519.pub
```

A passphrase is recommended for protecting the private key.

If you use a passphrase, configure an appropriate method for supplying the key during automation, such as an SSH agent or a supported credential-management workflow.

## 16.4 Copy the Public Key

For a lab environment where password-based SSH is available:

```bash
ssh-copy-id automation@192.168.1.101
```

Repeat for the second managed node:

```bash
ssh-copy-id automation@192.168.1.102
```

This installs the public key for the remote account.

If `ssh-copy-id` is unavailable, the public key can be installed manually in the account's `~/.ssh/authorized_keys` file with appropriate ownership and permissions.

## 16.5 Test SSH Connectivity

```bash
ssh automation@192.168.1.101
```

Then test the second host:

```bash
ssh automation@192.168.1.102
```

Exit the remote session:

```bash
exit
```

## 16.6 Common SSH Permission Requirements

The remote account's SSH directory and authorized keys file must have suitable ownership and permissions.

Common settings are:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

These commands must be applied to the relevant account on the managed node.

Do not change ownership or permissions blindly on an existing production system.

## 16.7 AWS EC2 SSH Access

When using EC2 instances:

- Use the correct private key for the instance.
- Use the correct operating-system username.
- Allow SSH from the control node's trusted network location.
- Verify the instance's network routing and security group rules.
- Never commit private keys to GitHub.

Common usernames vary by image. For example, Ubuntu images commonly use `ubuntu`, while Amazon Linux images commonly use `ec2-user`.

---

# 17. Configure Sudo and Privilege Escalation

## 17.1 What Is Privilege Escalation?

Ansible often connects to managed Linux servers as a regular user.

However, tasks such as installing packages, changing system configuration, or managing system services may require elevated privileges.

Privilege escalation allows Ansible to execute those tasks with the required permissions.

On Linux, Ansible commonly uses `sudo` through its `become` mechanism.

## 17.2 Example Without Privilege Escalation

```yaml
---
- name: Install Nginx
  hosts: webservers

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

If the SSH user does not have the required privileges, the package installation will fail.

## 17.3 Example With Privilege Escalation

```yaml
---
- name: Install Nginx
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

The `become: true` setting enables privilege escalation for the play.

## 17.4 Useful Become Settings

```yaml
become: true
become_method: sudo
become_user: root
```

These settings tell Ansible to use `sudo` to execute tasks as root.

## 17.5 Test Sudo Access

Log in to a managed node:

```bash
ssh automation@192.168.1.101
```

Check sudo permissions:

```bash
sudo -l
```

Test non-interactive sudo if your automation requires it:

```bash
sudo -n true
```

A successful `sudo -n true` indicates that this command can run without prompting for a password under the current configuration.

It does not prove that every administrative command is permitted.

## 17.6 Run a Playbook With a Become Password

If sudo requires a password:

```bash
ansible-playbook -i inventory.ini site.yml --ask-become-pass
```

The short form is:

```bash
ansible-playbook -i inventory.ini site.yml -K
```

Ansible prompts for the become password.

## 17.7 Security Best Practices

- Avoid running every task as root when unnecessary.
- Grant only the privileges required.
- Do not put sudo passwords in plaintext playbooks.
- Use Ansible Vault or an appropriate secrets manager for sensitive values.
- Test privilege escalation before running production automation.

---

# 18. Ansible Configuration Files

Ansible uses configuration settings to determine how commands and playbooks behave.

The primary configuration file is named:

```text
ansible.cfg
```

## 18.1 Common Configuration Locations

Ansible can discover configuration files from several locations.

Common locations include:

```text
./ansible.cfg
~/.ansible.cfg
/etc/ansible/ansible.cfg
```

A configuration file in the current project directory can be useful because it keeps project-specific settings together.

Ansible does not simply merge every configuration file it finds. It selects a configuration file according to its discovery rules.

For the standard configuration-file search order, consult the official documentation.

## 18.2 Project Structure

Create a project directory:

```bash
mkdir -p ~/ansible-zero-to-hero
cd ~/ansible-zero-to-hero
```

Create a basic project layout:

```bash
mkdir -p inventory playbooks
touch ansible.cfg
touch inventory/hosts.ini
touch playbooks/site.yml
```

The structure should look like this:

```text
ansible-zero-to-hero/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
└── playbooks/
    └── site.yml
```

## 18.3 Why Use a Project-Specific Configuration?

A project-specific configuration file can define:

- The default inventory path.
- The default remote user.
- The number of parallel tasks.
- Host-key checking behavior.
- Logging preferences.
- Other supported Ansible settings.

This makes the project easier to run consistently.

---

# 19. Understanding ansible.cfg

Let's configure a basic project.

## 19.1 Create ansible.cfg

Open the file:

```bash
nano ansible.cfg
```

Add:

```ini
[defaults]
inventory = ./inventory/hosts.ini
remote_user = automation
forks = 10
host_key_checking = True
```

Save the file.

### Explanation

| Setting | Purpose |
|---|---|
| `[defaults]` | Section containing general Ansible settings |
| `inventory` | Default inventory path |
| `remote_user` | Default SSH username |
| `forks` | Maximum number of parallel worker processes for applicable operations |
| `host_key_checking` | Controls SSH host-key verification behavior |

The settings shown are examples. Adjust them to your environment.

Keeping host-key checking enabled is the recommended security practice.

## 19.2 Create the Inventory

Open:

```bash
nano inventory/hosts.ini
```

Add:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102
```

Replace the sample IP addresses with your managed nodes' addresses.

## 19.3 Create a Playbook

Open:

```bash
nano playbooks/site.yml
```

Add:

```yaml
---
- name: Verify Ansible connectivity
  hosts: webservers
  gather_facts: false

  tasks:
    - name: Test connectivity
      ansible.builtin.ping:
```

## 19.4 Run the Playbook

From the project root:

```bash
ansible-playbook playbooks/site.yml
```

Because the configuration file defines the inventory path, you do not need to specify `-i` for this project command.

If you run the command from another directory, Ansible may not select the same project configuration. Run commands from the project root when relying on the local `ansible.cfg`.

## 19.5 Verify the Selected Configuration

Run:

```bash
ansible --version
```

Inspect the effective configuration:

```bash
ansible-config dump
```

You can inspect a particular setting:

```bash
ansible-config dump | grep -i DEFAULT_HOST_LIST
```

The exact output depends on your Ansible version and configuration.

**Security note:** A project-local `ansible.cfg` is not loaded from a world-writable current directory in supported Ansible configurations. Use a trusted project directory and avoid making it writable by untrusted users.

---

# 20. Configuration Precedence

Ansible configuration can be influenced by multiple sources.

For the main configuration settings, a useful general model is:

1. Configuration file settings.
2. Environment variables.
3. Command-line options.

In general, environment variables can override settings from the configuration file, and applicable command-line options can override both.

However, Ansible also has other precedence systems, particularly for variables and connection settings. Do not confuse configuration-file precedence with Ansible variable precedence.

## 20.1 Example: Configuration File

```ini
[defaults]
inventory = ./inventory/hosts.ini
```

This defines the default inventory path.

## 20.2 Example: Environment Variable

You can specify a configuration file explicitly:

```bash
export ANSIBLE_CONFIG=/path/to/ansible.cfg
```

Ansible will use that file, provided it is valid and accessible.

To remove the setting:

```bash
unset ANSIBLE_CONFIG
```

## 20.3 Example: Command-Line Option

You can override the configured inventory:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

The `-i` option specifies the inventory for that command.

## 20.4 Inspect the Effective Configuration

```bash
ansible-config dump
```

This is useful when Ansible is not behaving as expected.

For example, if the wrong inventory is being used, inspect the effective inventory setting before changing other parts of the project.

Official documentation:

https://docs.ansible.com/ansible/latest/reference_appendices/config.html

---

# 21. Your First Ansible Command

Now that you understand the fundamentals, run your first command against a managed node.

## 21.1 Verify Connectivity

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

Expected result:

```text
web01 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

web02 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

The output is illustrative.

The Ansible ping module verifies that Ansible can execute its module successfully on the remote host. It is not a network-level ping test.

## 21.2 Check Uptime

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

This executes the `uptime` command on the selected hosts.

## 21.3 Check Disk Usage

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

## 21.4 Check Memory

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "free -h"
```

## 21.5 Run Against One Host

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping
```

## 21.6 Run Against a Group

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping
```

## 21.7 Execute a Privileged Command

For a task that requires sudo, use the appropriate become options.

For example:

```bash
ansible webservers \
  -i inventory/hosts.ini \
  -b \
  -m ansible.builtin.command \
  -a "systemctl status nginx"
```

This assumes that the remote user has the required sudo permissions. If sudo requires a password, add `-K`.

The command's exit status may depend on the service state and the system's configuration.

---

# 22. Hands-On Lab 1: Build an Ansible Environment

## Lab Objective

Build a working Ansible environment that can connect to two Linux managed nodes, execute commands, and run a basic playbook.

## Lab Architecture

```text
                   YOUR WORKSTATION
                          |
                          v
                  ANSIBLE CONTROL
                  Ubuntu Linux
                          |
                    SSH / TCP 22
                          |
              +-----------+-----------+
              |                       |
              v                       v
         MANAGED NODE 1          MANAGED NODE 2
         Ubuntu Linux            Ubuntu Linux
         192.168.1.101            192.168.1.102
```

The IP addresses are examples.

## Lab Requirements

- One Linux control node.
- Two Linux managed nodes.
- Ansible installed on the control node.
- SSH connectivity.
- A non-root remote user.
- Python 3 available where required.

## Task 1: Verify Ansible

On the control node:

```bash
ansible --version
```

Record the installed version.

## Task 2: Create the Project

```bash
mkdir -p ~/ansible-zero-to-hero/inventory
mkdir -p ~/ansible-zero-to-hero/playbooks

cd ~/ansible-zero-to-hero

touch ansible.cfg
touch inventory/hosts.ini
touch playbooks/site.yml
```

## Task 3: Configure the Inventory

Edit `inventory/hosts.ini`:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[webservers:vars]
ansible_user=automation
```

Replace the sample IP addresses and username.

## Task 4: Configure SSH Authentication

Generate a key if you do not already have one:

```bash
ssh-keygen -t ed25519 -C "ansible-control"
```

Install the public key on each managed node:

```bash
ssh-copy-id automation@192.168.1.101
ssh-copy-id automation@192.168.1.102
```

Test the connections:

```bash
ssh automation@192.168.1.101
ssh automation@192.168.1.102
```

If password-based SSH is unavailable, install the public key using your environment's approved access method.

## Task 5: Configure ansible.cfg

Edit `ansible.cfg`:

```ini
[defaults]
inventory = ./inventory/hosts.ini
remote_user = automation
forks = 10
host_key_checking = True
```

## Task 6: Test Connectivity

From the project root:

```bash
ansible webservers -m ansible.builtin.ping
```

Both hosts should return successful results.

If not, proceed to the troubleshooting section.

## Task 7: Gather Basic Information

Check uptime:

```bash
ansible webservers -m ansible.builtin.command -a "uptime"
```

Check disk utilization:

```bash
ansible webservers -m ansible.builtin.command -a "df -h"
```

Check memory:

```bash
ansible webservers -m ansible.builtin.command -a "free -h"
```

## Task 8: Create Your First Playbook

Edit `playbooks/site.yml`:

```yaml
---
- name: Collect basic Linux server information
  hosts: webservers
  gather_facts: true

  tasks:
    - name: Display hostname
      ansible.builtin.debug:
        msg: "Managed hostname: {{ ansible_hostname }}"

    - name: Display operating system
      ansible.builtin.debug:
        msg: "Operating system: {{ ansible_distribution }}"

    - name: Display operating system version
      ansible.builtin.debug:
        msg: "OS version: {{ ansible_distribution_version }}"
```

## Task 9: Validate the Playbook

```bash
ansible-playbook playbooks/site.yml --syntax-check
```

## Task 10: Execute the Playbook

```bash
ansible-playbook playbooks/site.yml
```

Review the output and confirm that information was collected from both managed nodes.

## Task 11: Document Your Results

Create a lab report containing:

- Ansible version.
- Control node operating system.
- Managed node operating systems.
- SSH connectivity test results.
- Successful Ansible ping results.
- Playbook execution results.
- Any errors encountered and how you resolved them.

## Expected Result

At the end of the lab, you should have:

- A working Ansible installation.
- Two reachable managed nodes.
- SSH key-based authentication.
- A working inventory.
- A project-specific `ansible.cfg`.
- A successful ad hoc command.
- A successful playbook execution.

---

# 23. Troubleshooting Common Problems

## Problem 1: SSH Connection Refused

Example:

```text
ssh: connect to host 192.168.1.101 port 22: Connection refused
```

### Possible Causes

- SSH service is stopped.
- SSH is not installed.
- Wrong IP address or port.
- A firewall is rejecting the connection.

### Troubleshooting

Verify the IP address and check the SSH service on the managed node.

For Ubuntu, the service is commonly named `ssh`:

```bash
sudo systemctl status ssh
```

Verify that the managed node is listening on the intended SSH port.

Do not open SSH access to untrusted networks merely to resolve the error.

---

## Problem 2: Permission Denied

Example:

```text
Permission denied (publickey,password).
```

### Possible Causes

- Wrong SSH username.
- Public key is missing.
- Incorrect private key.
- Incorrect SSH file permissions.
- The server does not allow the selected authentication method.

### Troubleshooting

Test SSH independently:

```bash
ssh -v automation@192.168.1.101
```

Check that the correct public key is installed for the remote user.

Verify the username and key path in the Ansible configuration or inventory.

---

## Problem 3: Host Key Verification Failed

Example:

```text
Host key verification failed.
```

### Possible Causes

- The host's SSH key changed.
- The host was rebuilt.
- The known-hosts entry is stale.
- The connection is reaching a different machine than expected.

### Troubleshooting

Verify the server's identity through a trusted channel before changing the local known-hosts entry.

Do not automatically disable host-key checking as a general fix.

---

## Problem 4: Ansible Reports an Unreachable Host

Example:

```text
fatal: [web01]: UNREACHABLE!
```

### Troubleshooting

Check the following:

1. Is the host IP address correct?
2. Can you SSH into the host manually?
3. Is the remote username correct?
4. Is the SSH port accessible?
5. Are the SSH keys valid?
6. Is the managed node running?
7. Is the inventory parsed correctly?

Inspect the inventory:

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

Test connectivity:

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping -vvv
```

---

## Problem 5: Python Interpreter Error

Example:

```text
Failed to find a suitable Python interpreter.
```

### Possible Causes

- Python is missing on the managed node.
- The interpreter path is incorrect.
- The installed Python version is unsupported by the relevant Ansible version.

### Troubleshooting

Check the remote interpreter:

```bash
ssh automation@192.168.1.101 'python3 --version'
```

Install a supported interpreter if required.

If the interpreter is installed in a nonstandard location, configure the appropriate interpreter path after verifying it.

---

## Problem 6: Sudo Permission Denied

Example:

```text
Missing sudo password
```

or:

```text
Sorry, user automation is not allowed to execute ...
```

### Possible Causes

- Sudo requires a password.
- The user lacks the required sudo permissions.
- The sudoers policy restricts the requested operation.

### Troubleshooting

Check:

```bash
sudo -l
```

If appropriate, run the playbook with:

```bash
ansible-playbook playbooks/site.yml -K
```

Do not grant unrestricted root access merely to make a lab pass. Use the minimum privileges needed.

---

## Problem 7: The Wrong ansible.cfg Is Being Used

### Troubleshooting

Run:

```bash
ansible --version
```

Look for the selected configuration file.

Inspect effective settings:

```bash
ansible-config dump
```

Check the current working directory:

```bash
pwd
```

Check whether the environment specifies a configuration file:

```bash
echo "$ANSIBLE_CONFIG"
```

If the variable is set unexpectedly, investigate it before changing the project configuration.

---

# 24. Security Best Practices

Follow these practices from the beginning of your Ansible journey.

1. Use SSH key-based authentication where appropriate.
2. Keep private keys secret.
3. Never commit credentials to GitHub.
4. Use a dedicated automation account.
5. Apply least-privilege access.
6. Keep SSH host-key verification enabled.
7. Protect `ansible.cfg` and project directories from untrusted modification.
8. Use Ansible Vault or an appropriate secrets manager for sensitive data.
9. Test playbooks in development before production.
10. Review changes before applying them to critical servers.
11. Use check mode and diff mode where supported.
12. Avoid indiscriminate use of `ignore_errors`.
13. Keep Ansible and its dependencies updated.
14. Restrict network access to managed servers.
15. Review logs for sensitive information.

Check mode and diff mode are useful safeguards, but they do not guarantee that every module will predict the exact effect of a production execution.

---

# 25. Interview Questions and Answers

## Q1. What is Ansible?

Ansible is an automation tool used for configuration management, application deployment, orchestration, and operational automation.

## Q2. What is configuration management?

Configuration management is the process of defining, maintaining, and controlling system configurations to achieve consistency and reliability.

## Q3. What is a control node?

A control node is the machine from which Ansible commands and playbooks are executed.

## Q4. What is a managed node?

A managed node is a system that Ansible manages through an appropriate connection method.

## Q5. Why is Ansible called agentless?

For standard Linux SSH automation, Ansible does not require a continuously running Ansible agent on each managed host.

## Q6. How does Ansible connect to Linux servers?

It commonly uses SSH for remote access and executes the required modules on managed nodes.

## Q7. What is an inventory?

An inventory identifies the hosts and groups that Ansible can target.

## Q8. What is a playbook?

A playbook is a YAML file containing plays and tasks that describe automation.

## Q9. What is a module?

A module performs a specific operation, such as installing a package, copying a file, or managing a service.

## Q10. What is idempotency?

Idempotency means that repeating an operation does not continue changing the system after the intended state has been reached.

## Q11. Is every Ansible task idempotent?

No. Many Ansible modules support idempotent operations, but shell commands and custom scripts may produce repeated changes unless designed carefully.

## Q12. What is `ansible.cfg`?

It is an Ansible configuration file used to customize settings such as the default inventory, connection behavior, and execution options.

## Q13. What is SSH key-based authentication?

It is an authentication method that uses a public/private key pair rather than relying solely on a password.

## Q14. What is `become: true`?

It enables privilege escalation for a play, block, or task. On Linux, the common method is `sudo`.

## Q15. What is the difference between Ansible and Terraform?

Terraform primarily manages infrastructure provisioning and lifecycle through resource state, while Ansible is commonly used for configuration management and operational automation.

They can be combined in a workflow where Terraform provisions infrastructure and Ansible configures the resulting systems.

## Q16. What is the Ansible ping module?

`ansible.builtin.ping` checks Ansible's ability to communicate with a managed node and execute the module. It is not an ICMP ping.

## Q17. Why might Ansible report a host as unreachable?

Common reasons include network problems, SSH authentication failures, incorrect connection settings, or an unavailable SSH service.

## Q18. What is push-based automation?

It is a model in which the automation controller initiates operations against target systems.

Ansible's common SSH-based Linux workflow follows this model.

## Q19. Can Ansible manage AWS EC2 instances?

Yes. Ansible can discover instances using dynamic inventory and configure their operating systems and applications. Supported AWS collections can also manage cloud resources.

## Q20. Why should Ansible code be stored in Git?

Version control provides change history, collaboration, code review, and a foundation for repeatable CI/CD workflows.

---

# 26. Knowledge Assessment

Answer these questions without looking at the documentation.

### Beginner

1. What is configuration management?
2. What is Ansible used for?
3. What is the difference between a control node and a managed node?
4. What does agentless mean in Ansible?
5. What is an inventory?

### Intermediate

6. How does Ansible connect to a typical Linux server?
7. What is idempotency?
8. What is the difference between declarative and imperative automation?
9. What is the purpose of `ansible.cfg`?
10. Why might SSH key-based authentication fail?

### Practical

11. How would you verify your Ansible installation?
12. How would you test connectivity to two managed nodes?
13. How would you execute a command against a host group?
14. How would you configure privilege escalation?
15. How would you troubleshoot an unreachable host?

### Advanced Thinking

16. Why is agentless automation not dependency-free?
17. Why can shell commands cause repeated unwanted changes?
18. What is the difference between Ansible configuration precedence and variable precedence?
19. Why should SSH host-key checking normally remain enabled?
20. How would you combine Terraform and Ansible to deploy an application to AWS?

---

# 27. Module Completion Checklist

Before moving to Module 2, confirm that you can perform the following tasks.

- [ ] Explain configuration management.
- [ ] Explain Ansible architecture.
- [ ] Identify control nodes and managed nodes.
- [ ] Explain agentless automation.
- [ ] Explain push-based automation.
- [ ] Understand idempotency.
- [ ] Compare Ansible with Bash and Terraform.
- [ ] Install Ansible on a Linux control node.
- [ ] Verify the Ansible version.
- [ ] Inspect effective configuration settings.
- [ ] Configure SSH key-based authentication.
- [ ] Connect to two managed Linux nodes.
- [ ] Execute Ansible ad hoc commands.
- [ ] Configure a project-specific `ansible.cfg`.
- [ ] Run a basic Ansible playbook.
- [ ] Troubleshoot SSH connectivity.
- [ ] Explain privilege escalation.
- [ ] Document your lab in GitHub.

## Module 1 Completion Criteria

You are ready to proceed when you can independently configure an Ansible control node, connect to two Linux managed nodes, explain the execution workflow, and successfully execute a basic playbook.

Do not move forward simply because you have read the content. Complete the hands-on lab first.

---

# 28. References

Use the official documentation as your primary reference.

- [Ansible Official Documentation](https://docs.ansible.com/ansible/latest/index.html)
- [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Ansible Getting Started](https://docs.ansible.com/ansible/latest/getting_started/index.html)
- [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
- [Ansible Inventory Guide](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
- [Ansible Playbooks Introduction](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)
- [Ansible Privilege Escalation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html)

---

## Final Message

Ansible is not just a tool for running commands on multiple servers.

It helps you build repeatable automation for system configuration, application deployment, infrastructure operations, and operational maintenance.

As a Cloud and DevOps engineer, your objective should be to understand the problem, define the intended system state, automate the required changes, validate the results, and recover safely when something fails.

**Learn the concepts. Execute the labs. Troubleshoot the failures. Document the results. Repeat until you can do it independently.**