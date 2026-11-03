# Ansible Ad-hoc Commands – Complete Hands-on Practice Guide

## 📌 Overview

This documentation covers **Ansible Ad-hoc Commands** with practical examples for Linux system administration and DevOps automation.

Ansible Ad-hoc Commands allow administrators to execute one-time tasks on remote managed nodes without writing Ansible Playbooks.

This hands-on guide uses an **Ansible Controller and two Amazon Linux 2023 managed nodes** to practice connectivity checks, Linux administration, package management, service management, file transfers, system facts, and remote command execution.

**Learning Path:** Beginner → Intermediate → Advanced

---

## 🎯 Learning Objectives

By completing this hands-on practice, you will learn:

- Understand Ansible Ad-hoc command syntax.
- Establish SSH connectivity with managed nodes.
- Execute Linux commands remotely.
- Monitor CPU, memory, disk, and system information.
- Manage files, directories, users, and groups.
- Install and remove packages using DNF.
- Start, stop, restart, and enable Linux services.
- Transfer files between controller and managed nodes.
- Understand the difference between `command` and `shell` modules.
- Gather system information using Ansible Facts.
- Control execution using host patterns, limits, and forks.

---

## 🏗️ Lab Architecture

| Component | Configuration |
|---|---|
| Controller | Amazon Linux 2023 |
| Managed Node 1 | Amazon Linux 2023 |
| Managed Node 2 | Amazon Linux 2023 |
| Automation Tool | Ansible Core 2.15.3 |
| Python | Python 3.9 |
| SSH User | ec2-user |
| Authentication | SSH Private Key |
| Inventory | inventory/hosts |

### Lab Structure

```text
Ansible-Lab/
│
├── inventory/
│   └── hosts
│
├── playbooks/
│
└── README.md
```

### Inventory Configuration

File: `inventory/hosts`

```ini
[managed_nodes]

AnsibleNode1 ansible_host=172.31.18.73
AnsibleNode2 ansible_host=172.31.26.231
```

**Note:** Replace the IP addresses with your current managed-node private IP addresses if they change.

---

## 🔐 SSH Authentication

All remote execution commands explicitly specify the SSH username and private key.

```bash
-u ec2-user
```

Specifies the SSH login user.

```bash
--private-key ~/.ssh/Ansible_key
```

Specifies the SSH private key used for authentication.

```bash
-b
```

Enables privilege escalation using sudo.

### Standard Command Syntax

```bash
ansible <host-pattern> \
-i <inventory-file> \
-u <ssh-user> \
--private-key <private-key-path> \
-m <module> \
-a "<module-arguments>"
```

---

# 1. Connectivity & Basic System Information

### 1. Test connectivity

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m ping
```

### 2. Check hostname

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "hostname"
```

### 3. Check system uptime

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "uptime"
```

### 4. Check OS information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "cat /etc/os-release"
```

### 5. Check kernel version

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "uname -r"
```

### 6. Check current logged-in user

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "whoami"
```

### 7. Check system date

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "date"
```

---

# 2. Linux Resource Monitoring

### 8. Check disk utilization

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "df -Th"
```

### 9. Check memory utilization

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "free -h"
```

### 10. Check CPU cores

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "nproc"
```

### 11. Check CPU information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "lscpu"
```

### 12. Check running processes

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "ps -ef"
```

### 13. Check filesystem mounts

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "findmnt"
```

### 14. Check block devices

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "lsblk"
```

### 15. Check disk usage of log directory

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "du -sh /var/log"
```

---

# 3. File & Directory Management

The `file` module is used to create, modify, and remove files and directories.

### 16. Create directory

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops state=directory" -b
```

### 17. Create empty file

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops/hello.txt state=touch" -b
```

### 18. Change file permissions

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops/hello.txt mode=0644" -b
```

### 19. Change directory permissions

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops mode=0755" -b
```

### 20. Check directory contents

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "ls -l /opt/devops"
```

### 21. Delete file

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops/hello.txt state=absent" -b
```

### 22. Delete directory

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m file -a "path=/opt/devops state=absent" -b
```

---

# 4. Linux User & Group Management

The `user` and `group` modules help automate Linux account administration.

### 23. Create Linux user

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m user -a "name=devopsuser state=present" -b
```

### 24. Verify user

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "id devopsuser"
```

### 25. Create Linux group

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m group -a "name=devopsgroup state=present" -b
```

### 26. Add user to group

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m user -a "name=devopsuser groups=devopsgroup append=yes" -b
```

### 27. Verify group membership

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "groups devopsuser"
```

### 28. Delete Linux user

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m user -a "name=devopsuser state=absent remove=yes" -b
```

### 29. Delete Linux group

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m group -a "name=devopsgroup state=absent" -b
```

---

# 5. Package Management – DNF

Amazon Linux 2023 uses the DNF package manager.

The Ansible `dnf` module automates software installation, removal, and updates.

### 30. Check whether Nginx is installed

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "rpm -q nginx"
```

### 31. Install Nginx

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m dnf -a "name=nginx state=present" -b
```

### 32. Check Nginx version

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "nginx -v"
```

### 33. Remove Nginx

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m dnf -a "name=nginx state=absent" -b
```

### 34. Update all installed packages

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m dnf -a "name=* state=latest" -b
```

**Important:** Updating all packages can affect running applications. Perform updates only after appropriate testing and change approval.

---

# 6. Linux Service Management

The `service` module is used to manage Linux services remotely.

Install Nginx before executing these commands.

### 35. Start Nginx

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m service -a "name=nginx state=started" -b
```

### 36. Check Nginx status

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "systemctl status nginx"
```

### 37. Enable Nginx at boot

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m service -a "name=nginx enabled=yes" -b
```

### 38. Restart Nginx

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m service -a "name=nginx state=restarted" -b
```

### 39. Stop Nginx

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m service -a "name=nginx state=stopped" -b
```

### 40. Disable Nginx at boot

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m service -a "name=nginx enabled=no" -b
```

---

# 7. File Transfer – Copy & Fetch

Ansible provides two important modules for transferring files.

- `copy`: Transfers files from the controller to managed nodes.
- `fetch`: Retrieves files from managed nodes to the controller.

First, create a source file on the controller.

```bash
echo "Hello from Ansible Controller" > /home/ec2-user/test.txt
```

### 41. Copy file to managed nodes

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m copy -a "src=/home/ec2-user/test.txt dest=/tmp/test.txt"
```

### 42. Copy file with specific permissions

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m copy -a "src=/home/ec2-user/test.txt dest=/tmp/test.txt mode=0644"
```

### 43. Fetch file from managed nodes

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m fetch -a "src=/etc/os-release dest=/tmp/ansible-fetch/"
```

---

# 8. Command vs Shell Modules

Ansible provides two modules for executing Linux commands.

| Feature | command | shell |
|---|---|---|
| Executes Linux commands | Yes | Yes |
| Supports pipes | No | Yes |
| Supports redirection | No | Yes |
| Supports shell operators | No | Yes |
| Executes through shell | No | Yes |

### 44. Execute basic Linux command

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m command -a "ls -l /tmp"
```

### 45. Execute multiple commands using shell

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m shell -a "hostname && uptime"
```

### 46. Execute commands using pipes

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m shell -a "df -h | grep nvme"
```

### 47. Search for a process

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m shell -a "ps -ef | grep nginx"
```

### 48. Check HOME environment variable

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m shell -a "echo \$HOME"
```

**Best Practice:** Prefer the `command` module when shell features are not required. Use `shell` only when pipes, redirection, or shell operators are necessary.

---

# 9. Ansible Facts – System Information Gathering

Ansible Facts are system information automatically collected from managed nodes.

The `setup` module gathers facts such as OS distribution, CPU, memory, IP addresses, network interfaces, and hardware information.

### 49. Gather all system facts

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m setup
```

### 50. Gather distribution information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m setup -a "filter=ansible_distribution*"
```

### 51. Gather memory information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m setup -a "filter=ansible_memory_mb"
```

### 52. Gather processor information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m setup -a "filter=ansible_processor*"
```

### 53. Gather default IPv4 information

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m setup -a "filter=ansible_default_ipv4"
```

---

# 10. Host Targeting & Execution Control

Ansible allows commands to be executed against all hosts, specific hosts, or inventory groups.

### 54. Execute on all managed nodes

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m ping
```

### 55. Execute only on Node 1

```bash
ansible AnsibleNode1 -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m ping
```

### 56. Execute only on Node 2

```bash
ansible AnsibleNode2 -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m ping
```

### 57. Execute on a specific group

```bash
ansible managed_nodes -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -m ping
```

### 58. Limit execution to Node 1

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key --limit AnsibleNode1 -m command -a "hostname"
```

### 59. Execute with increased forks

```bash
ansible all -i inventory/hosts -u ec2-user --private-key ~/.ssh/Ansible_key -f 10 -m ping
```

### 60. Check Ansible version

```bash
ansible --version
```

### 61. Display inventory details

```bash
ansible-inventory -i inventory/hosts --list
```

### 62. List available hosts

```bash
ansible all -i inventory/hosts --list-hosts
```

---

# 📚 Important Ansible Modules Reference

| Module | Purpose |
|---|---|
| ping | Test Ansible connectivity |
| command | Execute Linux commands |
| shell | Execute commands using shell |
| file | Manage files and directories |
| copy | Transfer files to managed nodes |
| fetch | Retrieve files from managed nodes |
| user | Manage Linux users |
| group | Manage Linux groups |
| dnf | Install and remove packages |
| service | Manage Linux services |
| setup | Gather system facts |
| package | Generic package management |

---

# 🧠 Important Ansible Options Reference

| Option | Description |
|---|---|
| `-i` | Specify inventory file |
| `-u` | Specify remote SSH user |
| `--private-key` | Specify SSH private key |
| `-m` | Specify Ansible module |
| `-a` | Pass module arguments |
| `-b` | Enable privilege escalation |
| `-f` | Specify number of parallel forks |
| `--limit` | Restrict execution to selected hosts |
| `--list-hosts` | Display targeted hosts |
| `-v` | Enable verbose output |
| `-vvv` | Enable detailed debugging output |

---

# 🎯 Hands-on Practice Checklist

Complete these activities on both managed nodes.

- [ ] Verify SSH connectivity.
- [ ] Collect hostname and uptime.
- [ ] Monitor CPU, memory, and disk utilization.
- [ ] Create files and directories.
- [ ] Modify file permissions.
- [ ] Create and delete Linux users.
- [ ] Create and manage Linux groups.
- [ ] Install and remove Nginx.
- [ ] Start, stop, and restart Nginx.
- [ ] Enable services at system boot.
- [ ] Copy files from controller to managed nodes.
- [ ] Fetch files from managed nodes to controller.
- [ ] Practice command and shell modules.
- [ ] Gather Ansible Facts.
- [ ] Execute commands against individual nodes and groups.

---

# 🚀 Next Learning Steps

After completing Ansible Ad-hoc Commands, proceed to the following topics:

1. Ansible Configuration – `ansible.cfg`
2. Ansible Inventory – Static and Dynamic Inventory
3. Ansible Playbooks – YAML fundamentals
4. Ansible Variables and Data Types
5. Ansible Facts and Register Variables
6. Conditionals and Loops
7. Handlers and Notifications
8. Templates and Jinja2
9. Ansible Vault – Secret Management
10. Ansible Roles – Reusable Automation
11. Error Handling and Troubleshooting
12. Real-time Linux Administration Automation Projects

---

## 🏁 Conclusion

Ansible Ad-hoc Commands provide a simple way to perform remote administration across multiple Linux servers without creating playbooks.

These commands build the foundation for understanding Ansible modules, remote execution, privilege escalation, inventory management, and automation workflows.

**The next milestone is converting these individual Ad-hoc commands into reusable Ansible Playbooks and eventually organizing them into production-ready Ansible Roles.**

**Practice. Automate. Troubleshoot. Document. Repeat.**