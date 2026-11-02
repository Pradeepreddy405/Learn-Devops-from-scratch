# Ansible Ad-hoc Commands – Complete EC2 Hands-on Lab

![Ansible](https://img.shields.io/badge/Ansible-Automation-red?logo=ansible)
![AWS](https://img.shields.io/badge/AWS-EC2-orange?logo=amazonaws)
![Linux](https://img.shields.io/badge/Linux-Amazon%20Linux%202023-black?logo=linux)
![SSH](https://img.shields.io/badge/SSH-Key%20Authentication-green)
![Level](https://img.shields.io/badge/Level-Beginner%20to%20Intermediate-blue)

## 1. Project Overview

This project demonstrates how to configure Ansible from scratch using two AWS EC2 instances and perform Linux administration tasks remotely using Ansible Ad-hoc commands.

The objective is to understand how a Linux administrator or DevOps engineer can manage remote Linux servers without manually logging into each server.

### What we will learn

- EC2 infrastructure preparation.
- Security Group configuration.
- SSH key-based authentication.
- Ansible installation and verification.
- Ansible execution without `ansible.cfg`.
- Inventory file configuration.
- Ansible configuration using `ansible.cfg`.
- Linux administration using Ansible Ad-hoc commands.
- Package and service management.
- File, directory and user management.
- System monitoring and fact gathering.
- Nginx installation and deployment.
- Ansible troubleshooting and verification.

---

## 2. Lab Architecture

We will use two EC2 instances.

```text
                 AWS CLOUD
    ______________________________________

       EC2 INSTANCE 1
       ANSIBLE CONTROLLER
       Amazon Linux 2023

       Private Key:
       ~/.ssh/ansible_lab

       Ansible Installed
              |
              |
              | SSH Authentication
              | TCP Port 22
              |
              v
       EC2 INSTANCE 2
       ANSIBLE MANAGED NODE
       Amazon Linux 2023

       Public Key:
       ~/.ssh/authorized_keys

       Python Installed
       Nginx Deployment Target

    ______________________________________
```

### Instance details

| Configuration | Ansible Controller | Ansible Node |
|---|---|---|
| Operating System | Amazon Linux 2023 | Amazon Linux 2023 |
| Instance Type | t2.micro / t3.micro | t2.micro / t3.micro |
| Username | ec2-user | ec2-user |
| Ansible | Installed | Not required |
| Python 3 | Required | Required |
| SSH | Client | Server |
| Role | Execute automation | Receive automation |

Example private IP addresses:

```text
Controller: 172.31.24.205
Managed Node: 172.31.18.73
```

Replace these IP addresses with your actual EC2 private IP addresses.

---

## 3. Prerequisites

Before starting the lab, ensure the following:

1. AWS account.
2. Two running EC2 instances.
3. Amazon Linux 2023 AMI.
4. SSH access to both instances.
5. Security Group configured for private SSH communication.
6. Python 3 available on the managed node.
7. Basic Linux command-line knowledge.

---

# PHASE 1 – EC2 Infrastructure Setup

## 4. Launch Two EC2 Instances

Launch two separate EC2 instances.

### Instance 1 – Ansible Controller

- Operating System: Amazon Linux 2023.
- Instance Type: t2.micro or t3.micro.
- Username: ec2-user.
- Purpose: Install and execute Ansible.

### Instance 2 – Ansible Managed Node

- Operating System: Amazon Linux 2023.
- Instance Type: t2.micro or t3.micro.
- Username: ec2-user.
- Purpose: Receive and execute Ansible tasks.

## 5. Configure Security Groups

On the Managed Node's Security Group, configure the following inbound rule.

| Type | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | Controller Security Group |

**Important:** Use the Controller's Security Group as the source instead of allowing SSH from `0.0.0.0/0`.

The Controller must be able to connect to the Managed Node using its private IP address.

## 6. Verify Network Connectivity

Execute these commands from the Ansible Controller.

### Check ICMP connectivity

```bash
ping -c 4 172.31.18.73
```

Note: ICMP ping may fail if ICMP traffic is restricted. SSH connectivity is the important requirement.

### Check SSH port connectivity

```bash
nc -zv 172.31.18.73 22
```

Expected output:

```text
Connection to 172.31.18.73 22 port [tcp/ssh] succeeded!
```

This confirms that TCP port 22 is reachable.

---

# PHASE 2 – SSH Authentication Setup

## 7. Check SSH Availability on Controller

```bash
command -v ssh
```

```bash
ssh -V
```

## 8. Generate SSH Key Pair

On the Ansible Controller:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/ansible_lab
```

This generates two files.

```text
~/.ssh/
    |
    |-- ansible_lab
    |-- ansible_lab.pub
```

| File | Description |
|---|---|
| ansible_lab | Private key |
| ansible_lab.pub | Public key |

The private key must remain on the Controller.

## 9. Configure SSH Key Permissions

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/ansible_lab
chmod 644 ~/.ssh/ansible_lab.pub
```

## 10. Validate Public and Private Key Pair

### Display the public key derived from the private key

```bash
ssh-keygen -y -f ~/.ssh/ansible_lab
```

### Display the existing public key

```bash
cat ~/.ssh/ansible_lab.pub
```

Both should contain the same public key data.

### Automatically compare public keys

```bash
diff <(ssh-keygen -y -f ~/.ssh/ansible_lab) <(awk '{print $1, $2}' ~/.ssh/ansible_lab.pub)
```

If both keys match, there should be no output.

### Validate fingerprints

```bash
ssh-keygen -lf ~/.ssh/ansible_lab.pub
```

```bash
ssh-keygen -y -f ~/.ssh/ansible_lab | ssh-keygen -lf -
```

Both SHA256 fingerprints should match.

## 11. Copy Public Key to Managed Node

From the Controller:

```bash
ssh-copy-id -i ~/.ssh/ansible_lab.pub ec2-user@172.31.18.73
```

If `ssh-copy-id` is unavailable or you need to use a separate initial EC2 launch key:

On Controller:

```bash
cat ~/.ssh/ansible_lab.pub
```

Copy the complete output.

On Managed Node:

```bash
vi ~/.ssh/authorized_keys
```

Append the copied ED25519 public key as a new line.

Set permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**Important:** Do not copy the private key to the Managed Node.

## 12. Test SSH Authentication

From Controller:

```bash
ssh -i ~/.ssh/ansible_lab ec2-user@172.31.18.73
```

If authentication succeeds, you should be able to access the Managed Node without entering a password.

Exit:

```bash
exit
```

## 13. Verify Python on Managed Node

From Controller:

```bash
ssh -i ~/.ssh/ansible_lab ec2-user@172.31.18.73 "python3 --version"
```

Ansible requires Python on the Managed Node for most standard modules.

---

# PHASE 3 – Install Ansible on Controller

## 14. Check Whether Ansible Is Installed

```bash
ansible --version
```

If Ansible is not installed:

```bash
sudo dnf install ansible-core -y
```

Verify:

```bash
ansible --version
```

Check Python:

```bash
python3 --version
```

**Important:** Ansible is installed only on the Controller. You do not need to install Ansible on the Managed Node.

---

# PHASE 4 – Execute Ansible Without ansible.cfg

Initially, we will execute Ansible commands without creating an inventory file or Ansible configuration file.

## 15. Execute Your First Ansible Ping

```bash
ansible all -i 172.31.18.73, -m ping -u ec2-user --private-key ~/.ssh/ansible_lab
```

Expected output:

```text
172.31.18.73 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### Understanding the command

| Argument | Description |
|---|---|
| ansible | Executes an Ansible Ad-hoc command |
| all | Target all inventory hosts |
| -i | Specifies inventory |
| 172.31.18.73, | Single host inventory |
| -m ping | Executes Ansible ping module |
| -u ec2-user | SSH username |
| --private-key | SSH private key location |

**Why is the comma important?**

When directly specifying a single host as an inline inventory, use a trailing comma.

```bash
-i 172.31.18.73,
```

Without the comma, Ansible may interpret the value as an inventory filename.

## 16. Understand the General Ansible Command Structure

```bash
ansible <HOST_PATTERN> \
-i <INVENTORY> \
-m <MODULE> \
-a "<ARGUMENTS>" \
-u <SSH_USER> \
--private-key <PRIVATE_KEY>
```

Common options:

| Option | Purpose |
|---|---|
| -i | Inventory |
| -m | Module |
| -a | Module arguments |
| -u | Remote SSH user |
| -b | Privilege escalation |
| -v | Verbose output |
| -vvv | Debug-level verbose output |
| -K | Ask for sudo password |
| -f | Set parallel execution forks |

---

# PHASE 5 – Linux Administration Using Ansible Ad-hoc Commands

All commands in this section use the inline inventory approach.

The following examples assume that SSH authentication has already been configured.

## 17. Execute Basic Linux Commands

### 17.1 Check hostname

```bash
ansible all -i 172.31.18.73, -m command -a "hostname" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.2 Check operating system version

```bash
ansible all -i 172.31.18.73, -m command -a "cat /etc/os-release" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.3 Check kernel version

```bash
ansible all -i 172.31.18.73, -m command -a "uname -r" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.4 Check disk utilization

```bash
ansible all -i 172.31.18.73, -m command -a "df -Th" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.5 Check memory utilization

```bash
ansible all -i 172.31.18.73, -m command -a "free -h" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.6 Check system uptime

```bash
ansible all -i 172.31.18.73, -m command -a "uptime" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.7 Check block devices

```bash
ansible all -i 172.31.18.73, -m command -a "lsblk" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.8 Check running processes

```bash
ansible all -i 172.31.18.73, -m command -a "ps aux" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.9 Check IP addresses

```bash
ansible all -i 172.31.18.73, -m command -a "ip addr" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### 17.10 Check logged-in users

```bash
ansible all -i 172.31.18.73, -m command -a "who" -u ec2-user --private-key ~/.ssh/ansible_lab
```

## 18. Understand Command vs Shell Modules

### Command Module

Use the `command` module to execute standard Linux commands.

Example:

```bash
ansible all -i 172.31.18.73, -m command -a "df -Th" -u ec2-user --private-key ~/.ssh/ansible_lab
```

### Shell Module

Use the `shell` module when commands require pipes, redirection, environment variables or shell operators.

Example:

```bash
ansible all -i 172.31.18.73, -m shell -a "df -Th | grep xfs" -u ec2-user --private-key ~/.ssh/ansible_lab
```

Find Nginx processes:

```bash
ansible all -i 172.31.18.73, -m shell -a "ps aux | grep '[n]ginx'" -u ec2-user --private-key ~/.ssh/ansible_lab
```

Check the five largest directories under `/var`:

```bash
ansible all -i 172.31.18.73, -m shell -a "du -sh /var/* 2>/dev/null | sort -hr | head -5" -u ec2-user --private-key ~/.ssh/ansible_lab
```

---

# PHASE 6 – Configure Inventory File

We will now eliminate the need to specify the IP address repeatedly.

## 19. Create Project Directory

On Controller:

```bash
mkdir -p ~/ansible-raw-lab/inventory
cd ~/ansible-raw-lab
```

Expected structure:

```text
ansible-raw-lab/
    |
    |-- inventory/
```

## 20. Create Inventory File

```bash
vi inventory/hosts
```

Add:

```ini
[managed_nodes]
node1 ansible_host=172.31.18.73
```

Save the file.

## 21. Verify Inventory

```bash
ansible-inventory -i inventory/hosts --graph
```

Expected:

```text
@all:
  |--@managed_nodes:
  |  |--node1
```

## 22. Test Connectivity Using Inventory

```bash
ansible all -i inventory/hosts -m ping -u ec2-user --private-key ~/.ssh/ansible_lab
```

Alternatively:

```bash
ansible managed_nodes -i inventory/hosts -m ping -u ec2-user --private-key ~/.ssh/ansible_lab
```

The second command targets the specific inventory group.

---

# PHASE 7 – Configure ansible.cfg

Now we will eliminate repeated inventory, username and private-key arguments.

## 23. Create ansible.cfg

From the project directory:

```bash
vi ansible.cfg
```

Add:

```ini
[defaults]
inventory = ./inventory/hosts
remote_user = ec2-user
private_key_file = ~/.ssh/ansible_lab
host_key_checking = False
```

Save the file.

Note: Disabling host-key checking is convenient for this disposable lab, but production environments should retain SSH host-key verification.

## 24. Verify Ansible Configuration

```bash
ansible --version
```

Look for:

```text
config file = /home/ec2-user/ansible-raw-lab/ansible.cfg
```

Verify inventory:

```bash
ansible-inventory --graph
```

Test connectivity:

```bash
ansible all -m ping
```

Now the command is much shorter.

### Before ansible.cfg

```bash
ansible all -i inventory/hosts -m ping -u ec2-user --private-key ~/.ssh/ansible_lab
```

### After ansible.cfg

```bash
ansible all -m ping
```

This demonstrates why `ansible.cfg` is useful.

---

# PHASE 8 – Linux Administration Using Ansible Modules

From this point onwards, execute commands from the project directory.

```bash
cd ~/ansible-raw-lab
```

## 25. Package Management – DNF Module

Install Nginx:

```bash
ansible all -b -m dnf -a "name=nginx state=present"
```

Check installation:

```bash
ansible all -m command -a "rpm -q nginx"
```

Install Git:

```bash
ansible all -b -m dnf -a "name=git state=present"
```

Install HTTPD:

```bash
ansible all -b -m dnf -a "name=httpd state=present"
```

Install multiple packages:

```bash
ansible all -b -m dnf -a "name=nginx,git,wget,curl state=present"
```

Remove HTTPD:

```bash
ansible all -b -m dnf -a "name=httpd state=absent"
```

Update all installed packages:

```bash
ansible all -b -m dnf -a "name=* state=latest"
```

**Note:** The last command updates all installed packages. Review the impact before using it on important systems.

## 26. Service Management – Service Module

Start Nginx:

```bash
ansible all -b -m service -a "name=nginx state=started"
```

Stop Nginx:

```bash
ansible all -b -m service -a "name=nginx state=stopped"
```

Restart Nginx:

```bash
ansible all -b -m service -a "name=nginx state=restarted"
```

Reload Nginx:

```bash
ansible all -b -m service -a "name=nginx state=reloaded"
```

Enable Nginx at boot:

```bash
ansible all -b -m service -a "name=nginx enabled=yes"
```

Disable Nginx at boot:

```bash
ansible all -b -m service -a "name=nginx enabled=no"
```

Check service status:

```bash
ansible all -m command -a "systemctl is-active nginx"
```

Check whether it is enabled:

```bash
ansible all -m command -a "systemctl is-enabled nginx"
```

## 27. File and Directory Management – File Module

Create directory:

```bash
ansible all -b -m file -a "path=/opt/devops state=directory mode=0755"
```

Create file:

```bash
ansible all -b -m file -a "path=/opt/devops/test.txt state=touch mode=0644"
```

Change file permissions:

```bash
ansible all -b -m file -a "path=/opt/devops/test.txt mode=0600"
```

Change ownership:

```bash
ansible all -b -m file -a "path=/opt/devops/test.txt owner=ec2-user group=ec2-user"
```

Delete file:

```bash
ansible all -b -m file -a "path=/opt/devops/test.txt state=absent"
```

Delete directory and contents:

```bash
ansible all -b -m file -a "path=/opt/devops state=absent"
```

## 28. Copy Files to Managed Node – Copy Module

Create a source file on Controller:

```bash
echo "This file was deployed using Ansible" > ~/ansible-raw-lab/message.txt
```

Copy it to Node 1:

```bash
ansible all -b -m copy -a "src=message.txt dest=/opt/message.txt owner=ec2-user group=ec2-user mode=0644"
```

Verify:

```bash
ansible all -m command -a "cat /opt/message.txt"
```

Expected output:

```text
This file was deployed using Ansible
```

## 29. Create and Manage Linux Users – User Module

Create user:

```bash
ansible all -b -m user -a "name=devopsuser state=present"
```

Create system user:

```bash
ansible all -b -m user -a "name=monitoring state=present system=yes"
```

Verify user:

```bash
ansible all -m command -a "id devopsuser"
```

Remove user:

```bash
ansible all -b -m user -a "name=devopsuser state=absent"
```

## 30. Modify Configuration Files – Lineinfile Module

Add a line to `/etc/motd`:

```bash
ansible all -b -m lineinfile -a "path=/etc/motd line='Managed by Ansible'"
```

Verify:

```bash
ansible all -m command -a "cat /etc/motd"
```

Update the line:

```bash
ansible all -b -m lineinfile -a "path=/etc/motd regexp='^Managed by Ansible$' line='Managed by Ansible Controller'"
```

Remove the line:

```bash
ansible all -b -m lineinfile -a "path=/etc/motd state=absent regexp='^Managed by Ansible Controller$'"
```

## 31. Gather System Facts – Setup Module

Collect system information:

```bash
ansible all -m setup
```

Get hostname:

```bash
ansible all -m setup -a "filter=ansible_hostname"
```

Get total memory:

```bash
ansible all -m setup -a "filter=ansible_memtotal_mb"
```

Get processor information:

```bash
ansible all -m setup -a "filter=ansible_processor*"
```

Get distribution information:

```bash
ansible all -m setup -a "filter=ansible_distribution*"
```

## 32. Verify Files and Directories – Stat Module

Check whether Nginx configuration exists:

```bash
ansible all -m stat -a "path=/etc/nginx/nginx.conf"
```

Check whether a directory exists:

```bash
ansible all -m stat -a "path=/opt/devops"
```

The output provides information about existence, permissions, ownership and file type.

## 33. Download Files – Get_url Module

Download a public test file:

```bash
ansible all -b -m get_url -a "url=https://example.com/robots.txt dest=/tmp/robots.txt mode=0644"
```

Verify:

```bash
ansible all -m command -a "cat /tmp/robots.txt"
```

## 34. Schedule Cron Jobs – Cron Module

Create a cron job that records system uptime every five minutes:

```bash
ansible all -b -m cron -a "name='System uptime monitoring' minute=*/5 job='/usr/bin/uptime >> /var/log/ansible-uptime.log 2>&1'"
```

Verify:

```bash
ansible all -b -m command -a "crontab -l"
```

Remove the cron job:

```bash
ansible all -b -m cron -a "name='System uptime monitoring' state=absent"
```

## 35. Execute Commands With Different Verbosity Levels

Normal execution:

```bash
ansible all -m ping
```

Verbose execution:

```bash
ansible all -m ping -v
```

More detailed output:

```bash
ansible all -m ping -vvv
```

Check mode / dry run:

```bash
ansible all -b -m dnf -a "name=nginx state=present" --check
```

Diff mode:

```bash
ansible all -b -m lineinfile -a "path=/etc/motd line='Ansible Lab'" --diff
```

Note: Check mode simulates changes where supported. It is not a guarantee that every module can predict all changes.

---

# PHASE 9 – Nginx Deployment End-to-End

This exercise combines package installation, service management, file deployment and application verification.

## 36. Install Nginx

```bash
ansible all -b -m dnf -a "name=nginx state=present"
```

## 37. Start and Enable Nginx

```bash
ansible all -b -m service -a "name=nginx state=started enabled=yes"
```

## 38. Verify Nginx Service

```bash
ansible all -m command -a "systemctl is-active nginx"
```

Expected:

```text
active
```

Check HTTP response:

```bash
ansible all -m command -a "curl -I http://localhost"
```

Expected response:

```text
HTTP/1.1 200 OK
Server: nginx
```

## 39. Create Custom HTML Page on Controller

```bash
cat > index.html <<'EOF'
<html>
<head>
    <title>Ansible Deployment</title>
</head>
<body>
    <h1>Hello from Ansible!</h1>
    <p>Successfully deployed to EC2 Managed Node.</p>
</body>
</html>
EOF
```

## 40. Deploy HTML Page to Managed Node

```bash
ansible all -b -m copy -a "src=index.html dest=/usr/share/nginx/html/index.html owner=nginx group=nginx mode=0644"
```

## 41. Verify HTML Deployment

```bash
ansible all -m command -a "curl -s http://localhost"
```

Expected:

```html
<html>
<head>
    <title>Ansible Deployment</title>
</head>
<body>
    <h1>Hello from Ansible!</h1>
    <p>Successfully deployed to EC2 Managed Node.</p>
</body>
</html>
```

To access the website externally, configure an HTTP TCP 80 inbound Security Group rule restricted to the required client IP.

---

# PHASE 10 – Troubleshooting

## 42. SSH Permission Denied

Error:

```text
Permission denied (publickey)
```

Check private key:

```bash
ls -l ~/.ssh/ansible_lab
```

Check matching public key:

```bash
ssh-keygen -y -f ~/.ssh/ansible_lab
```

Check public key on Managed Node:

```bash
cat ~/.ssh/authorized_keys
```

Test SSH manually:

```bash
ssh -i ~/.ssh/ansible_lab ec2-user@172.31.18.73
```

## 43. Ansible Cannot Find Inventory

Error:

```text
[WARNING]: No inventory was parsed
```

Check inventory:

```bash
ansible-inventory --graph
```

Check configuration:

```bash
ansible --version
```

Check inventory file:

```bash
cat inventory/hosts
```

## 44. Python Interpreter Error

Check Python:

```bash
ssh -i ~/.ssh/ansible_lab ec2-user@172.31.18.73 "python3 --version"
```

If needed, configure the interpreter in inventory:

```ini
[managed_nodes]
node1 ansible_host=172.31.18.73 ansible_python_interpreter=/usr/bin/python3
```

## 45. Sudo Permission Issues

Use privilege escalation:

```bash
ansible all -b -m command -a "whoami"
```

Expected:

```text
root
```

If sudo requires a password:

```bash
ansible all -b -K -m command -a "whoami"
```

This prompts for the become password.

## 46. SSH Debugging

Use verbose SSH:

```bash
ssh -vvv -i ~/.ssh/ansible_lab ec2-user@172.31.18.73
```

Use verbose Ansible:

```bash
ansible all -m ping -vvv
```

These commands help identify SSH authentication, connectivity and execution problems.

---

# PHASE 11 – Learning Outcomes

After completing this lab, you should understand the following.

| Topic | Learning Outcome |
|---|---|
| EC2 | Launch and configure Linux servers |
| Security Groups | Configure private SSH communication |
| SSH | Understand public/private key authentication |
| Ansible | Install and configure Ansible |
| Inventory | Manage remote host information |
| ansible.cfg | Simplify repetitive command-line options |
| Ad-hoc | Execute remote Linux administration commands |
| Command | Run standard Linux commands |
| Shell | Execute commands with shell operators |
| DNF | Install and remove packages |
| Service | Manage Linux services |
| File | Manage files and directories |
| Copy | Transfer files to managed nodes |
| User | Manage Linux users |
| Lineinfile | Modify configuration files |
| Setup | Gather remote system facts |
| Stat | Inspect files and directories |
| Get_url | Download files to managed nodes |
| Cron | Schedule recurring jobs |
| Privilege escalation | Execute administrative operations |
| Troubleshooting | Diagnose SSH and Ansible failures |

---

# PHASE 12 – Practical Completion Checklist

Use this checklist to track your lab progress.

## Infrastructure and SSH

- [ ] Launch Controller EC2 instance.
- [ ] Launch Managed Node EC2 instance.
- [ ] Configure Security Groups.
- [ ] Verify TCP port 22 connectivity.
- [ ] Generate ED25519 SSH key pair.
- [ ] Validate public/private key pair.
- [ ] Configure authorized_keys on Managed Node.
- [ ] Verify passwordless SSH authentication.
- [ ] Verify Python on Managed Node.

## Ansible Configuration

- [ ] Install Ansible on Controller.
- [ ] Execute Ansible ping without ansible.cfg.
- [ ] Create project directory.
- [ ] Create inventory file.
- [ ] Verify inventory using ansible-inventory.
- [ ] Create ansible.cfg.
- [ ] Verify active Ansible configuration.
- [ ] Execute ping using ansible.cfg.

## Linux Administration

- [ ] Execute disk and memory monitoring commands.
- [ ] Execute system information commands.
- [ ] Understand command and shell modules.
- [ ] Install and remove packages.
- [ ] Start, stop and enable services.
- [ ] Create and remove files.
- [ ] Create and remove directories.
- [ ] Change permissions and ownership.
- [ ] Copy files to Managed Node.
- [ ] Create and remove Linux users.
- [ ] Modify configuration files.
- [ ] Gather Ansible facts.
- [ ] Inspect files using stat.
- [ ] Download files using get_url.
- [ ] Create and remove cron jobs.
- [ ] Understand verbose and check modes.

## Nginx Deployment

- [ ] Install Nginx.
- [ ] Start Nginx.
- [ ] Enable Nginx at boot.
- [ ] Verify Nginx service status.
- [ ] Verify HTTP response.
- [ ] Deploy custom HTML page.
- [ ] Verify deployed website.

---

# PHASE 13 – Next Learning Roadmap

After completing this Ad-hoc lab, proceed to the following topics.

| Level | Topic | Objective |
|---|---|---|
| Beginner | YAML fundamentals | Understand YAML syntax |
| Beginner | Playbook fundamentals | Automate Linux tasks |
| Intermediate | Variables | Reuse configurations |
| Intermediate | Loops | Automate repetitive tasks |
| Intermediate | Conditionals | Implement decision-making |
| Intermediate | Handlers | Trigger service restarts |
| Intermediate | Templates | Generate configuration files |
| Intermediate | Facts | Use dynamic system information |
| Advanced | Roles | Build reusable automation |
| Advanced | Vault | Protect sensitive information |
| Advanced | Error handling | Handle failures |
| Advanced | Ansible tags | Execute selected tasks |
| Advanced | Ansible Galaxy | Reuse community roles |
| Production | Multi-node deployment | Manage multiple EC2 instances |
| Production | CI/CD integration | Automate Ansible execution |
| Production | Troubleshooting | Solve real infrastructure problems |

---

## Repository Structure

Recommended GitHub repository structure:

```text
Ansible_Practice_Hands/
│
├── README.md
│
├── 01_EC2_Infrastructure/
│   └── README.md
│
├── 02_SSH_Authentication/
│   └── README.md
│
├── 03_Ansible_Configuration/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── hosts
│   └── README.md
│
├── 04_Adhoc_Commands/
│   ├── 01_system_information.md
│   ├── 02_disk_memory_monitoring.md
│   ├── 03_package_management.md
│   ├── 04_service_management.md
│   ├── 05_file_management.md
│   ├── 06_user_management.md
│   ├── 07_configuration_management.md
│   ├── 08_facts_gathering.md
│   └── 09_cron_management.md
│
├── 05_Nginx_Deployment/
│   ├── index.html
│   └── README.md
│
└── 06_Troubleshooting/
    └── README.md
```

**Security reminder:** Do not commit private SSH keys, AWS credentials, passwords, or production secrets. Use placeholder IP addresses in public documentation and exclude local secret files from Git.

---

## Final Project Summary

This hands-on project demonstrates how to configure Ansible using two AWS EC2 instances and perform remote Linux administration using Ansible Ad-hoc commands.

Starting from EC2 infrastructure preparation and SSH key authentication, the lab progresses through Ansible installation, inventory management, configuration setup, system monitoring, package installation, service management, user management, file operations, cron scheduling and Nginx deployment.

The project establishes the foundation for moving from manual Linux administration to automated infrastructure management using Ansible.

**Next milestone:** Convert these Ad-hoc Linux administration commands into reusable YAML Ansible Playbooks.