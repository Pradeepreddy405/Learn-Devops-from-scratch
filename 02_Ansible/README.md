# Ansible Zero to Hero: A Complete Guide for Cloud & DevOps Engineers

Learn Ansible from absolute fundamentals to advanced automation with practical examples, hands-on labs, real-world scenarios, and projects designed for **Linux Administration, AWS Cloud, DevOps, SRE, and Platform Engineering roles**.

This repository provides a structured learning path to help you understand Ansible, automate Linux infrastructure, manage configurations, deploy applications, and integrate automation into CI/CD pipelines.

---

## 🎯 Goal

Master Ansible automation to:

- Automate Linux server administration.
- Manage users, groups, permissions, packages, and services.
- Configure multiple servers consistently.
- Write reusable Ansible playbooks and roles.
- Automate AWS EC2 configuration.
- Deploy applications using Ansible.
- Integrate Ansible with Jenkins and GitHub Actions.
- Manage secrets securely using Ansible Vault.
- Troubleshoot automation failures.
- Build practical projects for Cloud and DevOps job interviews.

---

## 📚 Prerequisites

Before starting this roadmap, you should understand the following fundamentals:

- Linux commands and administration.
- Users, groups, permissions, and sudo.
- SSH and remote server access.
- Basic networking concepts.
- Git and GitHub fundamentals.
- YAML syntax.
- Basic AWS EC2 concepts.

**Recommended lab environment:**

- One Ansible control node.
- Two Linux managed nodes.
- Ubuntu or another supported Linux distribution.
- SSH access between machines.
- Python 3 on managed nodes where required.
- Git for version control.

You can use local virtual machines or AWS EC2 instances.

---

# Module 1: Ansible Fundamentals

## Topics

- What is configuration management?
- What is Ansible?
- Why do DevOps engineers use Ansible?
- Ansible architecture.
- Control node and managed nodes.
- Agentless architecture.
- Push-based automation.
- Declarative configuration management.
- Idempotency.
- Ansible use cases in Cloud and DevOps.
- Ansible vs Bash scripting.
- Ansible vs Terraform.
- Ansible vs Puppet and Chef.

## Hands-on

- Install Ansible on a Linux control node.
- Verify the Ansible installation.
- Prepare two managed Linux servers.
- Establish SSH connectivity.
- Execute your first Ansible command.
- Understand the Ansible execution workflow.

## Outcome

Understand how Ansible communicates with managed servers and why configuration management is important in production environments.

---

# Module 2: Ansible Installation and Environment Setup

## Topics

- Installing Ansible on Ubuntu.
- Installing Ansible on supported Linux distributions.
- Python and SSH prerequisites.
- SSH key generation.
- Public-key authentication.
- SSH configuration.
- Sudo access.
- Ansible configuration files.
- Understanding `ansible.cfg`.
- Understanding the default configuration paths.
- Environment variables.
- Ansible version management.

## Important Commands

```bash
ansible --version
ansible-config list
ansible-config dump
ansible-config view
```

## Hands-on

- Configure an Ansible control node.
- Create SSH keys for automation.
- Configure SSH access to managed nodes.
- Test connectivity.
- Configure a project-specific `ansible.cfg`.
- Troubleshoot SSH authentication failures.

## Outcome

Build a working Ansible environment and understand its configuration.

---

# Module 3: Ansible Inventory Management

## Topics

- What is an inventory?
- Static inventory.
- INI inventory format.
- YAML inventory format.
- Host definitions.
- Host groups.
- Parent and child groups.
- Group variables.
- Host variables.
- Inventory patterns.
- Inventory aliases.
- Multiple environments.
- Inventory validation.
- Introduction to dynamic inventory.

## Example Inventory

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[appservers]
app01 ansible_host=192.168.1.103

[production:children]
webservers
appservers

[all:vars]
ansible_user=ubuntu
```

Replace the sample addresses and username with your lab configuration.

## Important Commands

```bash
ansible-inventory -i inventory.ini --list

ansible-inventory -i inventory.ini --graph

ansible all -i inventory.ini --list-hosts
```

## Hands-on

- Create an inventory for multiple Linux servers.
- Group servers by application role.
- Separate development and production inventories.
- Execute commands against selected groups.
- Troubleshoot inventory parsing issues.

## Outcome

Manage multiple servers efficiently using structured inventories.

---

# Module 4: Ansible Ad Hoc Commands

## Topics

- What are ad hoc commands?
- Command syntax.
- Modules and arguments.
- Targeting individual hosts.
- Targeting groups.
- Remote command execution.
- Privilege escalation.
- Parallel execution.
- Output interpretation.
- Return codes and failure handling.

## Important Modules

- `ansible.builtin.ping`
- `ansible.builtin.command`
- `ansible.builtin.shell`
- `ansible.builtin.copy`
- `ansible.builtin.file`
- `ansible.builtin.package`
- `ansible.builtin.service`
- `ansible.builtin.user`
- `ansible.builtin.group`
- `ansible.builtin.debug`

## Hands-on

- Test connectivity across servers.
- Collect uptime and operating system information.
- Check disk and memory utilization.
- Create Linux users.
- Install packages.
- Manage services.
- Copy files to multiple servers.

## Outcome

Execute one-time administrative tasks across multiple servers without creating a playbook for each operation.

---

# Module 5: YAML Fundamentals for Ansible

## Topics

- YAML syntax.
- Key-value pairs.
- Lists and dictionaries.
- Nested data structures.
- Boolean values.
- Strings and numbers.
- Indentation rules.
- YAML comments.
- Quoting values.
- YAML syntax errors.
- YAML formatting best practices.

## Example

```yaml
---
application:
  name: payment-service
  environment: development
  port: 8080

packages:
  - nginx
  - git
  - curl
```

## Hands-on

- Create valid YAML files.
- Represent application configuration using dictionaries.
- Define package lists.
- Identify common indentation errors.
- Create variables for Ansible playbooks.

## Outcome

Write readable and valid YAML for automation projects.

---

# Module 6: Ansible Playbooks

## Topics

- What is a playbook?
- Playbook structure.
- Plays and tasks.
- Target hosts.
- Module usage.
- Fact gathering.
- Task execution order.
- Multiple plays.
- Privilege escalation using `become`.
- Playbook execution.
- Syntax validation.
- Verbose output.
- Check mode and diff mode.

## Example Playbook

```yaml
---
- name: Configure Linux web servers
  hosts: webservers
  become: true
  gather_facts: true

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

## Important Commands

```bash
ansible-playbook -i inventory.ini site.yml

ansible-playbook -i inventory.ini site.yml --syntax-check

ansible-playbook -i inventory.ini site.yml --check

ansible-playbook -i inventory.ini site.yml -v
```

## Hands-on

- Write your first playbook.
- Install software on multiple servers.
- Configure services.
- Collect server information.
- Validate playbook syntax.
- Troubleshoot failed tasks.

## Outcome

Automate repeatable administrative tasks using structured playbooks.

---

# Module 7: Ansible Modules

## Topics

- What are Ansible modules?
- Module documentation.
- Module arguments.
- Return values.
- Idempotent modules.
- Module error handling.
- Built-in modules.
- Platform-specific modules.
- Collections and fully qualified collection names.

## Important Modules to Learn

| Module | Purpose |
|---|---|
| `ansible.builtin.ping` | Test Ansible connectivity |
| `ansible.builtin.command` | Execute commands without shell processing |
| `ansible.builtin.shell` | Execute shell commands |
| `ansible.builtin.copy` | Copy files |
| `ansible.builtin.file` | Manage files, directories, and permissions |
| `ansible.builtin.template` | Generate files using Jinja2 templates |
| `ansible.builtin.package` | Manage software packages |
| `ansible.builtin.apt` | Manage APT packages |
| `ansible.builtin.dnf` | Manage DNF packages |
| `ansible.builtin.service` | Manage services |
| `ansible.builtin.systemd_service` | Manage systemd services |
| `ansible.builtin.user` | Manage users |
| `ansible.builtin.group` | Manage groups |
| `ansible.builtin.stat` | Inspect files and directories |
| `ansible.builtin.fetch` | Retrieve files from managed nodes |
| `ansible.builtin.lineinfile` | Manage individual lines in files |
| `ansible.builtin.blockinfile` | Manage blocks of text in files |
| `ansible.builtin.debug` | Display variables and messages |
| `ansible.builtin.assert` | Validate conditions |

## Hands-on

- Install and remove packages.
- Create users and groups.
- Configure directories and permissions.
- Manage service states.
- Modify configuration files.
- Collect files from remote servers.

## Outcome

Choose the appropriate module for common Linux administration tasks.

---

# Module 8: Variables and Facts

## Topics

- What are Ansible variables?
- Play variables.
- Inventory variables.
- Host variables.
- Group variables.
- Variables from external files.
- Registered variables.
- Facts and gathered system information.
- Custom facts.
- Jinja2 variable expressions.
- Variable precedence.
- Variable reuse across environments.

## Example