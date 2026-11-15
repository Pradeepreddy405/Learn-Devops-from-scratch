# Module 3: YAML, Playbooks, Modules, Variables, and Facts

## 1. Module Overview

Welcome to **Module 3 of Ansible Zero to Hero**.

In Module 1, you learned Ansible fundamentals and setup. In Module 2, you explored inventory management and ad hoc commands.

In this module, you will learn how to write **Ansible playbooks** to automate repetitive Linux administration tasks across multiple servers.

Instead of executing commands manually on every server, you will define the desired tasks in YAML and let Ansible execute them in a predictable, repeatable manner.

### Learning Objectives

By the end of this module, you will be able to:

- Understand YAML syntax and data structures.
- Write Ansible playbooks with multiple plays and tasks.
- Use Ansible modules to manage Linux systems.
- Create and manage users, groups, files, directories, and services.
- Install and configure Nginx.
- Define variables and reuse them across environments.
- Gather system facts and use conditional logic.
- Register task output and use it in subsequent tasks.
- Apply tags to execute selected tasks.
- Validate playbooks using syntax checks, check mode, and diff mode.
- Follow basic Ansible security and production best practices.

---

# 2. Prerequisites

Before starting this module, make sure you have:

- Basic Linux administration knowledge.
- Basic SSH knowledge.
- Ansible installed on a control node.
- Access to at least one Linux managed node.
- SSH connectivity from the control node to managed nodes.
- An inventory file containing your target hosts.
- Sudo privileges on managed nodes when administrative tasks require them.

Check your Ansible installation:

```bash
ansible --version
```

Check your inventory:

```bash
ansible-inventory -i inventory.ini --graph
```

Test connectivity:

```bash
ansible all -i inventory.ini -m ansible.builtin.ping
```

> **Important:** The Ansible `ping` module does not send ICMP packets. It checks whether Ansible can connect to the managed host and execute its Python-based module.

---

# 3. YAML Fundamentals

## 3.1 What Is YAML?

YAML stands for **YAML Ain't Markup Language**.

It is a human-readable data serialization format commonly used to define configuration files.

Ansible uses YAML to describe playbooks, tasks, variables, and other automation configurations.

For example:

```yaml
name: Install Nginx
package:
  name: nginx
  state: present
```

This describes an operation that ensures the Nginx package is installed.

### Why Does Ansible Use YAML?

YAML makes automation easier to read and maintain.

Instead of writing multiple commands manually, you can define the desired configuration in a structured file.

For example, instead of manually installing Nginx on five servers, you can write one playbook and execute it against all five servers.

---

## 3.2 YAML Key-Value Pairs

YAML represents data using key-value pairs.

Example:

```yaml
application: nginx
port: 80
environment: development
```

Here:

- `application` is a key.
- `nginx` is its value.
- `port` is a key.
- `80` is its value.

In an Ansible playbook:

```yaml
- name: Install web server
  hosts: webservers
  become: true
  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

Important keys include:

| Key | Purpose |
|---|---|
| `name` | Describes a play or task |
| `hosts` | Specifies the target hosts |
| `become` | Enables privilege escalation |
| `tasks` | Defines the operations to execute |
| `ansible.builtin.package` | Manages package installation and removal |
| `state` | Defines the desired package state |

---

## 3.3 YAML Lists

A list contains multiple items.

Example:

```yaml
packages:
  - nginx
  - git
  - curl
  - unzip
```

In Ansible, you can use a list to install several packages:

```yaml
- name: Install required packages
  hosts: all
  become: true

  tasks:
    - name: Install packages
      ansible.builtin.package:
        name:
          - nginx
          - git
          - curl
        state: present
```

This is generally better than creating a separate package-installation task for every package.

---

## 3.4 YAML Dictionaries

A dictionary contains multiple key-value pairs.

Example:

```yaml
server:
  hostname: web01
  environment: production
  port: 80
```

You can access individual values using variable expressions:

```yaml
- name: Display server hostname
  ansible.builtin.debug:
    msg: "Server hostname is {{ server.hostname }}"
```

The expression:

```jinja2
{{ server.hostname }}
```

references the `hostname` value inside the `server` dictionary.

---

## 3.5 YAML Indentation

YAML uses indentation to represent relationships between data elements.

Example:

```yaml
- name: Configure web servers
  hosts: webservers
  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

Notice the indentation:

- `hosts` and `tasks` belong to the play.
- The task belongs to the `tasks` list.
- `name` and `state` belong to the module configuration.

### Common YAML Mistakes

Incorrect:

```yaml
tasks:
- name: Install Nginx
  ansible.builtin.package:
    name: nginx
      state: present
```

The indentation before `state` is incorrect.

Correct:

```yaml
tasks:
  - name: Install Nginx
    ansible.builtin.package:
      name: nginx
      state: present
```

### YAML Best Practices

- Use spaces, not tabs, for indentation.
- Use consistent indentation, commonly two spaces per level.
- Keep task names descriptive.
- Avoid unnecessary nesting.
- Quote strings when doing so improves clarity or avoids YAML ambiguity.
- Validate YAML through Ansible's syntax checker.

---

## 3.6 YAML Data Types

YAML supports different data types.

### Strings

```yaml
application_name: nginx
environment: "production"
```

### Numbers

```yaml
port: 8080
retry_count: 3
```

### Boolean Values

```yaml
enable_monitoring: true
maintenance_mode: false
```

### Lists

```yaml
required_packages:
  - nginx
  - git
  - curl
```

### Dictionaries

```yaml
application:
  name: nginx
  port: 8080
  enabled: true
```

**Important:** YAML parsing rules can vary by YAML version and parser. When a value must clearly be a string, quote it.

For example:

```yaml
application_version: "3.0"
```

---

# 4. Understanding Ansible Playbooks

## 4.1 What Is an Ansible Playbook?

An Ansible playbook is a YAML file that defines the automation tasks Ansible should execute on selected managed hosts.

Playbooks are useful for:

- Installing software.
- Configuring web servers.
- Managing Linux users.
- Creating directories and files.
- Managing services.
- Deploying applications.
- Configuring monitoring agents.
- Applying repeatable infrastructure configurations.

Example:

```yaml
---
- name: Install Nginx
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx package
      ansible.builtin.package:
        name: nginx
        state: present
```

Save this file as:

```text
install-nginx.yml
```

Execute it:

```bash
ansible-playbook -i inventory.ini install-nginx.yml
```

Ansible connects to the hosts in the `webservers` group and executes the task.

---

## 4.2 Understanding a Playbook Structure

Consider this playbook:

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

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
```

### Explanation

| Component | Explanation |
|---|---|
| `---` | Optional YAML document-start marker |
| `name` | Descriptive play name |
| `hosts` | Target inventory group |
| `become` | Runs applicable tasks with elevated privileges |
| `gather_facts` | Collects system information before tasks |
| `tasks` | Contains tasks executed in sequence |
| `package` | Ensures the package is installed |
| `service` | Ensures the service is running and enabled at boot |

### Important Concepts

**Play:** Defines the target hosts and the operations to perform.

**Task:** Represents one operation in a play.

**Module:** Performs the actual operation on a managed host.

**Inventory:** Defines the hosts and groups against which a playbook runs.

**Variable:** Stores a reusable value.

**Fact:** Represents information collected about a managed host.

---

## 4.3 How Playbooks Execute

A typical playbook execution follows this sequence:

1. Ansible reads the inventory.
2. Ansible parses the playbook.
3. Ansible selects hosts matching the `hosts` pattern.
4. Ansible gathers facts if enabled.
5. Ansible executes tasks in order.
6. Ansible reports task results.
7. Ansible displays a recap of the execution.

For a single play, tasks are normally processed in the order in which they appear.

With the default linear strategy, Ansible generally completes each task across the active hosts before moving to the next task.

Execution across hosts can be parallel, depending on the strategy and fork settings.

---

# 5. Your First Multi-Task Playbook

Create a project directory:

```bash
mkdir -p ansible-module-03
cd ansible-module-03
```

Create a playbook:

```bash
vi first-playbook.yml
```

Add:

```yaml
---
- name: Perform basic Linux administration
  hosts: all
  become: true
  gather_facts: true

  tasks:
    - name: Display a welcome message
      ansible.builtin.debug:
        msg: "Ansible automation is running on {{ inventory_hostname }}"

    - name: Create a DevOps directory
      ansible.builtin.file:
        path: /opt/devops
        state: directory
        owner: root
        group: root
        mode: "0755"

    - name: Create a learning status file
      ansible.builtin.copy:
        dest: /opt/devops/status.txt
        content: |
          Managed by Ansible
          Module: 3
          Host: {{ inventory_hostname }}
        owner: root
        group: root
        mode: "0644"

    - name: Verify the status file
      ansible.builtin.stat:
        path: /opt/devops/status.txt
      register: status_file

    - name: Display file verification result
      ansible.builtin.debug:
        var: status_file.stat.exists
```

### Execute the Playbook

Validate syntax:

```bash
ansible-playbook -i inventory.ini first-playbook.yml --syntax-check
```

Execute:

```bash
ansible-playbook -i inventory.ini first-playbook.yml
```

Verify on a managed host:

```bash
ls -l /opt/devops/
cat /opt/devops/status.txt
```

### What Did You Learn?

- How to write a playbook.
- How to execute multiple tasks.
- How to create directories.
- How to create files.
- How to register task results.
- How to display information with the debug module.

---

# 6. Ansible Modules

Ansible modules perform specific operations on managed hosts.

Instead of writing shell commands for every operation, you can use modules designed to manage system resources.

Modules commonly help with:

- Package management.
- File management.
- User management.
- Service management.
- Configuration management.
- System inspection.
- Validation and error handling.

The examples below use fully qualified collection names, such as `ansible.builtin.copy`.

This makes the module being used explicit.

## 6.1 Command Module

The `ansible.builtin.command` module executes a command without passing it through a shell.

Example:

```yaml
- name: Check system uptime
  ansible.builtin.command: uptime
  register: uptime_output
  changed_when: false

- name: Display uptime
  ansible.builtin.debug:
    var: uptime_output.stdout
```

### Important Characteristics

- Does not interpret shell pipes, redirection, or shell operators.
- Is suitable for straightforward command execution.
- Does not automatically determine whether an arbitrary command changed the system.
- May require `changed_when` to report an appropriate change status.

Ad hoc example:

```bash
ansible all -i inventory.ini -m ansible.builtin.command -a "uptime"
```

---

## 6.2 Shell Module

The `ansible.builtin.shell` module executes a command through the remote shell.

Example:

```yaml
- name: Check the top five memory-consuming processes
  ansible.builtin.shell: ps aux | sort -rk 4 | head -n 6
  register: process_output
  changed_when: false

- name: Display process information
  ansible.builtin.debug:
    var: process_output.stdout_lines
```

Use `shell` when you need shell functionality, such as:

- Pipes (`|`).
- Redirection (`>`).
- Shell operators.
- Shell variable expansion.

Prefer dedicated Ansible modules when available.

> **Security note:** Avoid placing untrusted input directly into shell commands. Prefer modules or the `command` module with argument lists when practical.

---

## 6.3 Copy Module

The `ansible.builtin.copy` module copies files from the control node to managed hosts or creates files with specified content.

Example:

```yaml
- name: Deploy a custom index page
  ansible.builtin.copy:
    dest: /var/www/html/index.html
    content: |
      <html>
        <head>
          <title>Ansible Demo</title>
        </head>
        <body>
          <h1>Hello from Ansible</h1>
        </body>
      </html>
    owner: root
    group: root
    mode: "0644"
```

Run the task with sufficient privileges to write to the destination.

---

## 6.4 File Module

The `ansible.builtin.file` module manages files, directories, symbolic links, and permissions.

### Create a Directory

```yaml
- name: Create application directory
  ansible.builtin.file:
    path: /opt/myapp
    state: directory
    owner: root
    group: root
    mode: "0755"
```

### Create an Empty File

```yaml
- name: Create application log file
  ansible.builtin.file:
    path: /var/log/myapp.log
    state: touch
    owner: root
    group: root
    mode: "0644"
```

### Change Permissions

```yaml
- name: Set configuration permissions
  ansible.builtin.file:
    path: /opt/myapp
    state: directory
    mode: "0750"
```

### Remove a File

```yaml
- name: Remove temporary file
  ansible.builtin.file:
    path: /tmp/old-file.txt
    state: absent
```

**Warning:** The `absent` state removes the specified resource. Verify the path before running destructive tasks.

---

## 6.5 Package Module

The `ansible.builtin.package` module provides a common interface for package managers supported by Ansible.

Example:

```yaml
- name: Install required packages
  ansible.builtin.package:
    name:
      - nginx
      - git
      - curl
    state: present
```

This can work across several Linux distributions, provided the packages exist in their configured repositories.

For platform-specific behavior, use `apt` or `dnf` when necessary.

### APT Module

Primarily used on Debian and Ubuntu systems.

```yaml
- name: Install Nginx on Debian-based systems
  ansible.builtin.apt:
    name: nginx
    state: present
    update_cache: true
    cache_valid_time: 3600
```

### DNF Module

Primarily used on Fedora and modern RHEL-family systems.

```yaml
- name: Install Nginx on DNF-based systems
  ansible.builtin.dnf:
    name: nginx
    state: present
```

Package names and repository availability vary by distribution.

---

## 6.6 Service Module

The `ansible.builtin.service` module manages services across supported service-management systems.

Example:

```yaml
- name: Start and enable Nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

Common service states:

| State | Meaning |
|---|---|
| `started` | Ensure the service is running |
| `stopped` | Ensure the service is stopped |
| `restarted` | Restart the service |
| `reloaded` | Request a service reload when supported |

`enabled: true` configures the service to start automatically at boot when supported.

## 6.7 systemd_service Module

The `ansible.builtin.systemd_service` module manages services on systems using systemd.

Example:

```yaml
- name: Restart Nginx using systemd
  ansible.builtin.systemd_service:
    name: nginx
    state: restarted
    enabled: true
```

Use `systemd_service` when you need systemd-specific service management.

---

## 6.8 User and Group Modules

### Create a Group

```yaml
- name: Create DevOps group
  ansible.builtin.group:
    name: devops
    state: present
```

### Create a User

```yaml
- name: Create automation user
  ansible.builtin.user:
    name: automation
    group: devops
    create_home: true
    shell: /bin/bash
    state: present
```

### Remove a User

```yaml
- name: Remove temporary user
  ansible.builtin.user:
    name: temporary-user
    state: absent
    remove: false
```

With `remove: false`, the task does not request removal of the user's home directory and related files.

User removal can affect running processes, ownership, and access. Review the impact before deleting accounts.

---

## 6.9 Stat Module

The `ansible.builtin.stat` module collects information about a file or directory.

Example:

```yaml
- name: Inspect Nginx configuration
  ansible.builtin.stat:
    path: /etc/nginx/nginx.conf
  register: nginx_config

- name: Display configuration status
  ansible.builtin.debug:
    msg: "Nginx configuration exists: {{ nginx_config.stat.exists }}"
```

The registered result contains file metadata, depending on the resource and options used.

This is useful for:

- Checking whether a file exists.
- Inspecting permissions.
- Checking ownership.
- Validating files before making changes.

---

## 6.10 Fetch Module

The `ansible.builtin.fetch` module copies a file from a managed host to the control node.

Example:

```yaml
- name: Collect Nginx configuration
  ansible.builtin.fetch:
    src: /etc/nginx/nginx.conf
    dest: ./collected-configs/
    flat: false
```

By default, the destination structure includes information about the source host.

This is useful when collecting configuration files, logs, or diagnostic artifacts from multiple servers.

Ensure you have authorization to collect the files and protect any sensitive information they contain.

---

## 6.11 Debug Module

The `ansible.builtin.debug` module displays messages or variable values during execution.

Example:

```yaml
- name: Display the managed host
  ansible.builtin.debug:
    msg: "Managing {{ inventory_hostname }}"
```

Display a variable:

```yaml
- name: Display operating system facts
  ansible.builtin.debug:
    var: ansible_distribution
```

The debug module is useful when learning, troubleshooting, and inspecting registered results.

Avoid printing secrets in production logs.

---

## 6.12 Lineinfile Module

The `ansible.builtin.lineinfile` module ensures that a line exists, is absent, or matches a specified configuration pattern.

Example:

```yaml
- name: Ensure application port is configured
  ansible.builtin.lineinfile:
    path: /opt/myapp/application.conf
    regexp: '^port='
    line: 'port=8080'
    create: true
    owner: root
    group: root
    mode: "0644"
```

This task replaces a matching `port=` line or adds the desired line if no match exists.

Use `lineinfile` for simple line-level changes. For complex configuration files, consider templates or purpose-built modules.

---

## 6.13 Blockinfile Module

The `ansible.builtin.blockinfile` module manages a block of text within a file.

Example:

```yaml
- name: Add managed application configuration
  ansible.builtin.blockinfile:
    path: /opt/myapp/application.conf
    create: true
    block: |
      application_name=myapp
      environment=development
      port=8080
    owner: root
    group: root
    mode: "0644"
```

Ansible manages the block using marker lines by default.

This is useful for maintaining a clearly identified section of a configuration file.

---

## 6.14 Assert Module

The `ansible.builtin.assert` module verifies that conditions are true.

Example:

```yaml
- name: Verify that the expected port is configured
  ansible.builtin.assert:
    that:
      - app_port | int > 0
      - app_port | int < 65536
    fail_msg: "The application port is invalid."
    success_msg: "The application port is valid."
```

This example assumes `app_port` is defined.

Assertions are useful for validating inputs and preventing automation from continuing with invalid configuration.

---

## 6.15 Fail Module

The `ansible.builtin.fail` module stops execution with a custom error message.

Example:

```yaml
- name: Stop if the application environment is undefined
  ansible.builtin.fail:
    msg: "Set app_environment before deploying the application."
  when: app_environment is not defined
```

Use `fail` when a required condition is not satisfied and execution must stop.

---

# 7. Installing and Configuring Nginx

Let's build a practical playbook that installs Nginx, creates a web page, and starts the service.

Create:

```bash
vi nginx-setup.yml
```

Add:

```yaml
---
- name: Install and configure Nginx
  hosts: webservers
  become: true
  gather_facts: true

  vars:
    web_package: nginx
    web_root: /var/www/html
    web_port: 80

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: "{{ web_package }}"
        state: present
      tags:
        - install

    - name: Create web root directory
      ansible.builtin.file:
        path: "{{ web_root }}"
        state: directory
        owner: root
        group: root
        mode: "0755"
      tags:
        - configure

    - name: Deploy the website
      ansible.builtin.copy:
        dest: "{{ web_root }}/index.html"
        content: |
          <!DOCTYPE html>
          <html>
          <head>
            <title>Ansible Web Server</title>
          </head>
          <body>
            <h1>Hello from Ansible</h1>
            <p>Managed host: {{ inventory_hostname }}</p>
            <p>Environment: {{ app_environment | default('development') }}</p>
          </body>
          </html>
        owner: root
        group: root
        mode: "0644"
      tags:
        - configure

    - name: Start and enable Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
      tags:
        - service
```

Run the playbook:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml
```

Check service status on a managed server:

```bash
systemctl status nginx
```

Check the website locally on the managed server:

```bash
curl http://localhost/
```

If the service is running but the website cannot be accessed from your workstation, check firewall rules, cloud security groups, routing, and network access.

### Execute Specific Tags

List available tags:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --list-tags
```

Execute only installation tasks:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --tags install
```

Execute only service tasks:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --tags service
```

**Important:** Running a tag does not automatically execute all prerequisite tasks. If you run only the `service` tag, the package installation task will be skipped. Ensure the service already exists or run the required tags together.

---

# 8. Variables in Ansible

## 8.1 What Are Variables?

Variables store reusable values.

Without variables, you might hard-code the same package name, directory, or port in several tasks.

Variables make playbooks easier to maintain and adapt.

Example:

```yaml
vars:
  package_name: nginx
  service_name: nginx
  app_port: 8080
```

Use variables with Jinja2 expressions:

```yaml
- name: Display application details
  ansible.builtin.debug:
    msg: "Application {{ package_name }} uses port {{ app_port }}"
```

The expression:

```jinja2
{{ app_port }}
```

is replaced with the variable's value when the expression is evaluated.

---

## 8.2 Play-Level Variables

Play-level variables apply to the play in which they are defined.

Example:

```yaml
---
- name: Configure application
  hosts: webservers
  become: true

  vars:
    app_name: myapp
    app_port: 8080

  tasks:
    - name: Display application configuration
      ansible.builtin.debug:
        msg: "{{ app_name }} runs on port {{ app_port }}"
```

---

## 8.3 Variables in External Files

For larger projects, separate variables from playbook logic.

Create a directory:

```bash
mkdir -p group_vars
```

Create:

```bash
vi group_vars/webservers.yml
```

Add:

```yaml
---
app_name: myapp
app_port: 8080
app_environment: development
web_root: /var/www/html
```

Your inventory should contain a group named `webservers`.

For example:

```ini
[webservers]
web01 ansible_host=192.0.2.11
web02 ansible_host=192.0.2.12
```

A common project structure is:

```text
ansible-project/
├── inventory.ini
├── nginx-setup.yml
└── group_vars/
    └── webservers.yml
```

When running from the project directory:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml
```

Ansible can automatically load applicable variables from `group_vars/` and `host_vars/` directories associated with inventory groups and hosts.

For predictable variable loading, keep these directories in the expected inventory or playbook directory structure and consult the Ansible documentation for your project layout.

---

## 8.4 Host Variables

Host variables define values for individual machines.

Example inventory:

```ini
[webservers]
web01 ansible_host=192.0.2.11 app_port=8080
web02 ansible_host=192.0.2.12 app_port=8081
```

In this example:

- `web01` uses port `8080`.
- `web02` uses port `8081`.

For larger inventories, keep host-specific values in `host_vars/` files instead of placing every variable in the inventory.

Example:

```text
host_vars/
├── web01.yml
└── web02.yml
```

`host_vars/web01.yml`:

```yaml
---
app_port: 8080
```

`host_vars/web02.yml`:

```yaml
---
app_port: 8081
```

---

## 8.5 Registered Variables

Registered variables capture the result returned by a task.

Example:

```yaml
---
- name: Collect system information
  hosts: all
  gather_facts: true

  tasks:
    - name: Run uptime command
      ansible.builtin.command: uptime
      register: uptime_result
      changed_when: false

    - name: Display uptime
      ansible.builtin.debug:
        var: uptime_result.stdout

    - name: Display command return code
      ansible.builtin.debug:
        var: uptime_result.rc
```

Common fields in a registered command result include:

| Field | Meaning |
|---|---|
| `stdout` | Standard output as a string |
| `stdout_lines` | Standard output as a list of lines |
| `stderr` | Standard error as a string |
| `rc` | Command return code |
| `changed` | Whether Ansible reported a change for the task |
| `failed` | Whether the task failed |

Registered results are useful when later tasks need to inspect earlier command output.

---

## 8.6 Conditional Variable Usage

Ansible supports conditions using `when`.

Example:

```yaml
- name: Install Nginx on Debian-based systems
  ansible.builtin.apt:
    name: nginx
    state: present
  become: true
  when: ansible_os_family == "Debian"
```

For RHEL-family systems:

```yaml
- name: Install Nginx on Red Hat-family systems
  ansible.builtin.dnf:
    name: nginx
    state: present
  become: true
  when: ansible_os_family == "RedHat"
```

A single playbook can contain tasks for multiple operating-system families, with conditions selecting the appropriate tasks.

For many cross-platform package installations, the generic `package` module is simpler.

---

# 9. Understanding Ansible Facts

## 9.1 What Are Facts?

Facts are system details collected by Ansible from managed hosts.

They can include:

- Operating system distribution.
- Operating system version.
- Hostname.
- Network interfaces.
- IP addresses.
- CPU information.
- Memory information.
- Mount points and filesystems.
- Architecture.

By default, Ansible gathers facts at the beginning of a play when `gather_facts: true`.

Example:

```yaml
---
- name: Collect Linux system facts
  hosts: all
  gather_facts: true

  tasks:
    - name: Display hostname
      ansible.builtin.debug:
        var: ansible_hostname

    - name: Display operating system
      ansible.builtin.debug:
        var: ansible_distribution

    - name: Display operating system version
      ansible.builtin.debug:
        var: ansible_distribution_version

    - name: Display architecture
      ansible.builtin.debug:
        var: ansible_architecture
```

Run it:

```bash
ansible-playbook -i inventory.ini facts.yml
```

---

## 9.2 Disable Fact Gathering

Fact gathering can take time, particularly when managing many hosts.

If the play does not need facts, you can disable gathering:

```yaml
---
- name: Execute a simple task
  hosts: all
  gather_facts: false

  tasks:
    - name: Display hostname from inventory
      ansible.builtin.debug:
        var: inventory_hostname
```

`inventory_hostname` is an Ansible inventory variable, not a gathered system fact.

Disable fact gathering only when the play does not depend on those facts.

---

## 9.3 Conditional Execution Using Facts

Example:

```yaml
---
- name: Install packages based on operating system
  hosts: all
  become: true
  gather_facts: true

  tasks:
    - name: Install Nginx on Debian-based systems
      ansible.builtin.apt:
        name: nginx
        state: present
        update_cache: true
      when: ansible_os_family == "Debian"

    - name: Install Nginx on Red Hat-family systems
      ansible.builtin.dnf:
        name: nginx
        state: present
      when: ansible_os_family == "RedHat"
```

This demonstrates OS-based branching.

Before deploying a multi-distribution playbook, verify that the required package manager and package names are appropriate for every target distribution.

---

## 9.4 Custom Facts

Custom facts allow you to expose additional information about a managed host.

Ansible can read local custom facts from files under `/etc/ansible/facts.d/` on a managed host.

For example, create a file on the managed host:

```text
/etc/ansible/facts.d/application.fact
```

Example contents:

```ini
[application]
name=myapp
environment=production
port=8080
```

The file can be read as a local fact when Ansible gathers facts.

A playbook can create the directory and deploy the file:

```yaml
---
- name: Configure custom application facts
  hosts: all
  become: true

  tasks:
    - name: Create custom facts directory
      ansible.builtin.file:
        path: /etc/ansible/facts.d
        state: directory
        mode: "0755"

    - name: Deploy application fact file
      ansible.builtin.copy:
        dest: /etc/ansible/facts.d/application.fact
        content: |
          [application]
          name=myapp
          environment=production
          port=8080
        mode: "0644"

    - name: Gather facts after deploying custom facts
      ansible.builtin.setup:
        filter: ansible_local
```

You can then inspect the custom facts:

```yaml
- name: Display custom application fact
  ansible.builtin.debug:
    var: ansible_local.application
```

For the INI-style fact file above, the resulting values are generally represented as strings. Custom facts are useful for exposing local application metadata to later automation.

---

# 10. Jinja2 Expressions and Filters

Ansible uses Jinja2 templating for variable substitution, expressions, and filters.

## 10.1 Variable Substitution

```yaml
vars:
  app_name: myapp
  app_port: 8080

tasks:
  - name: Display application details
    ansible.builtin.debug:
      msg: "Application {{ app_name }} listens on port {{ app_port }}"
```

## 10.2 Default Filter

The `default` filter provides a fallback value when a variable is undefined.

```yaml
- name: Display environment
  ansible.builtin.debug:
    msg: "Environment: {{ app_environment | default('development') }}"
```

This is useful when an environment variable is optional.

## 10.3 Convert Values to Integers

```yaml
- name: Validate application port
  ansible.builtin.assert:
    that:
      - app_port | int > 0
      - app_port | int < 65536
```

The `int` filter converts a value to an integer for comparison.

## 10.4 Convert a Value to Uppercase

```yaml
- name: Display uppercase environment
  ansible.builtin.debug:
    msg: "{{ app_environment | upper }}"
```

If `app_environment` is `production`, the result is `PRODUCTION`.

## 10.5 Use a List of Lines

Registered command output often contains a `stdout_lines` list.

```yaml
- name: Display uptime output line by line
  ansible.builtin.debug:
    var: uptime_result.stdout_lines
```

### Commonly Useful Filters

| Filter | Purpose |
|---|---|
| `default()` | Provide a fallback value |
| `int` | Convert a value to an integer |
| `string` | Convert a value to a string |
| `upper` | Convert text to uppercase |
| `lower` | Convert text to lowercase |
| `length` | Count items or characters |
| `join()` | Combine list elements into a string |
| `unique` | Remove duplicate list elements |
| `sort` | Sort a sequence |

Filter behavior depends on the input type. Validate data types before applying filters to complex values.

---

# 11. Variable Precedence

Ansible allows variables to be defined in multiple locations.

For example, a value might be defined in:

- Inventory variables.
- `group_vars/`.
- `host_vars/`.
- Play-level `vars`.
- External variable files.
- Registered variables.
- Extra variables passed through the command line.

When multiple definitions apply to the same variable, Ansible uses its variable precedence rules to determine the effective value.

### Example

Inventory:

```ini
[webservers]
web01 ansible_host=192.0.2.11

[webservers:vars]
app_port=8080
```

Playbook:

```yaml
---
- name: Demonstrate variable precedence
  hosts: webservers

  vars:
    app_port: 9090

  tasks:
    - name: Display the application port
      ansible.builtin.debug:
        var: app_port
```

Run:

```bash
ansible-playbook -i inventory.ini variables.yml
```

The play-level `app_port` value overrides the inventory group variable in this example, so the result is `9090`.

Now run:

```bash
ansible-playbook -i inventory.ini variables.yml -e "app_port=7070"
```

The extra variable overrides the previous values, so the result is `7070`.

### Practical Rule

Avoid defining the same variable in many places unless you have a clear reason.

For maintainable projects:

- Keep environment-specific values in appropriate variable files.
- Use descriptive variable names.
- Document important overrides.
- Avoid relying on obscure precedence interactions.
- Use extra variables carefully because they have very high precedence.

For advanced work, consult the official Ansible variable-precedence documentation.

---

# 12. Tags and Selective Execution

Tags allow you to select particular tasks from a playbook.

Example:

```yaml
---
- name: Configure a web server
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
      tags:
        - install

    - name: Deploy website content
      ansible.builtin.copy:
        dest: /var/www/html/index.html
        content: "Hello from Ansible\n"
        mode: "0644"
      tags:
        - configure

    - name: Start Nginx
      ansible.builtin.service:
        name: nginx
        state: started
        enabled: true
      tags:
        - service
```

List tags:

```bash
ansible-playbook -i inventory.ini webserver.yml --list-tags
```

List tasks:

```bash
ansible-playbook -i inventory.ini webserver.yml --list-tasks
```

Execute only installation:

```bash
ansible-playbook -i inventory.ini webserver.yml --tags install
```

Execute installation and configuration:

```bash
ansible-playbook -i inventory.ini webserver.yml --tags "install,configure"
```

Skip configuration:

```bash
ansible-playbook -i inventory.ini webserver.yml --skip-tags configure
```

### Tagging Best Practices

- Use consistent tags such as `install`, `configure`, `deploy`, and `service`.
- Keep tag names meaningful.
- Understand which prerequisite tasks will be skipped.
- Test selective execution before using it in production.

---

# 13. Privilege Escalation with `become`

Many Linux administration tasks require root privileges.

Examples include:

- Installing packages.
- Modifying system configuration.
- Creating system users.
- Managing system services.
- Writing files under `/etc`.

Ansible supports privilege escalation through `become`.

Example:

```yaml
---
- name: Install system packages
  hosts: webservers
  become: true

  tasks:
    - name: Install Nginx
      ansible.builtin.package:
        name: nginx
        state: present
```

### Enable Privilege Escalation at Runtime

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --become
```

If a sudo password is required:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --become --ask-become-pass
```

The short option for `--ask-become-pass` is `-K`.

### Run as a Specific User

```yaml
- name: Execute application maintenance
  hosts: webservers
  become: true
  become_user: root

  tasks:
    - name: Display current effective user
      ansible.builtin.command: id
      register: identity
      changed_when: false

    - name: Display identity
      ansible.builtin.debug:
        var: identity.stdout
```

Use privilege escalation only where necessary. Prefer a dedicated automation account with narrowly scoped permissions rather than granting unnecessary administrative access.

---

# 14. Syntax Checking, Check Mode, and Diff Mode

Before applying changes, validate your playbooks.

## 14.1 Syntax Check

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --syntax-check
```

This checks playbook syntax and structure. It does not guarantee that every task will succeed on the target hosts.

## 14.2 List Tasks

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --list-tasks
```

Review the tasks Ansible recognizes before execution.

## 14.3 Check Mode

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --check
```

Check mode simulates changes where supported.

It is useful for previewing potential changes, but not every module supports check mode equally. Some tasks may be skipped or may not predict their real execution accurately.

## 14.4 Diff Mode

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --diff
```

Diff mode displays changes for supported tasks, such as modifications to managed files.

Be careful when using diff mode with sensitive configuration files. Output may expose secrets.

## 14.5 Combine Validation Options

```bash
ansible-playbook \
  -i inventory.ini \
  nginx-setup.yml \
  --syntax-check
```

Then preview:

```bash
ansible-playbook \
  -i inventory.ini \
  nginx-setup.yml \
  --check \
  --diff
```

Finally, execute:

```bash
ansible-playbook -i inventory.ini nginx-setup.yml
```

### Recommended Workflow

1. Review the inventory.
2. Validate YAML and playbook syntax.
3. Review the task list.
4. Run check mode where supported.
5. Review diffs where appropriate.
6. Execute against a test environment.
7. Verify the final state.
8. Promote the automation to higher environments through a controlled process.

---

# 15. Hands-On Labs

## Lab 1: Write Your First Multi-Task Playbook

### Objective

Create a playbook that performs several basic Linux administration tasks.

### Requirements

- Display the target host.
- Create `/opt/devops`.
- Create a file named `learning.txt`.
- Set appropriate permissions.
- Verify the file exists.

### Validation

```bash
ansible-playbook -i inventory.ini lab1.yml --syntax-check
ansible-playbook -i inventory.ini lab1.yml
```

On the managed host:

```bash
ls -l /opt/devops/
cat /opt/devops/learning.txt
```

---

## Lab 2: Install and Configure Nginx

### Objective

Automate Nginx installation and basic website deployment.

### Requirements

- Install Nginx.
- Create a web page.
- Start the Nginx service.
- Enable it at boot.
- Verify the website response.

### Validation

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --syntax-check
ansible-playbook -i inventory.ini nginx-setup.yml
```

On the managed host:

```bash
systemctl is-active nginx
curl http://localhost/
```

---

## Lab 3: Create Users and Groups

### Objective

Create a Linux group and user using Ansible.

### Requirements

- Create a group named `devops`.
- Create a user named `automation`.
- Assign the user to the group.
- Create the user's home directory.
- Set the user's login shell.

### Validation

```bash
getent group devops
id automation
getent passwd automation
```

**Security requirement:** Do not hard-code plaintext passwords into playbooks or commit credentials to GitHub.

---

## Lab 4: Manage Files, Directories, and Permissions

### Objective

Use the `file` and `copy` modules to manage filesystem resources.

### Requirements

- Create `/opt/myapp`.
- Create an application configuration file.
- Set ownership and permissions.
- Verify the file exists.
- Remove a temporary file safely.

### Validation

```bash
ls -ld /opt/myapp
ls -l /opt/myapp/
stat /opt/myapp/application.conf
```

---

## Lab 5: Register Command Output

### Objective

Capture the output of a command and use it in later tasks.

Example:

```yaml
---
- name: Register and display uptime
  hosts: all
  gather_facts: false

  tasks:
    - name: Execute uptime
      ansible.builtin.command: uptime
      register: uptime_result
      changed_when: false

    - name: Display uptime
      ansible.builtin.debug:
        msg: "{{ uptime_result.stdout }}"

    - name: Display return code
      ansible.builtin.debug:
        var: uptime_result.rc

    - name: Confirm command succeeded
      ansible.builtin.assert:
        that:
          - uptime_result.rc == 0
        fail_msg: "The uptime command failed."
```

### Validation

```bash
ansible-playbook -i inventory.ini lab5.yml
```

---

## Lab 6: Collect System Facts and Generate Server Reports

### Objective

Collect system information from every managed host.

### Requirements

- Gather hostname and OS details.
- Collect CPU and memory information.
- Identify filesystem mount points.
- Create a report for each host on the control node.

Example:

```yaml
---
- name: Generate server reports
  hosts: all
  gather_facts: true

  tasks:
    - name: Create local reports directory
      ansible.builtin.file:
        path: ./reports
        state: directory
        mode: "0755"
      delegate_to: localhost
      run_once: true

    - name: Write a report for each host
      ansible.builtin.copy:
        dest: "./reports/{{ inventory_hostname }}.txt"
        content: |
          Hostname: {{ ansible_hostname }}
          Inventory Host: {{ inventory_hostname }}
          Operating System: {{ ansible_distribution }}
          OS Version: {{ ansible_distribution_version }}
          Architecture: {{ ansible_architecture }}
          CPU Count: {{ ansible_processor_vcpus | default('unknown') }}
          Total Memory MB: {{ ansible_memtotal_mb | default('unknown') }}
          Filesystems:
          {% for mount in ansible_mounts | default([]) %}
          - {{ mount.mount }}: {{ mount.size_total | default(0) }} bytes total
          {% endfor %}
        mode: "0644"
      delegate_to: localhost
```

### Validation

After running the playbook, check the `reports/` directory on the control node:

```bash
ls -l reports/
cat reports/web01.txt
```

Replace `web01.txt` with the filename corresponding to your inventory alias.

**Note:** `ansible_memtotal_mb` is expressed in megabytes. The filesystem section reports total capacity, not free space. For operational monitoring, also collect available capacity and filesystem usage where required.

---

## Lab 7: Use Variables Across Environments

### Objective

Use different application settings for development and production.

Example directory structure:

```text
ansible-project/
├── inventory/
│   ├── dev.ini
│   └── prod.ini
├── group_vars/
│   └── webservers.yml
├── vars/
│   ├── dev.yml
│   └── prod.yml
└── deploy.yml
```

Example `vars/dev.yml`:

```yaml
---
app_environment: development
app_port: 8080
```

Example `vars/prod.yml`:

```yaml
---
app_environment: production
app_port: 80
```

Example `deploy.yml`:

```yaml
---
- name: Display environment configuration
  hosts: webservers
  gather_facts: false

  vars_files:
    - vars/dev.yml

  tasks:
    - name: Display application configuration
      ansible.builtin.debug:
        msg: "Environment={{ app_environment }}, Port={{ app_port }}"
```

Run development configuration:

```bash
ansible-playbook -i inventory/dev.ini deploy.yml
```

For production, change the applicable `vars_files` entry to `vars/prod.yml` or use a deliberate environment-selection design.

**Important:** The example above is fixed to development until the playbook is changed. For a reusable deployment workflow, consider selecting the variable file through a validated variable, separate environment-specific playbooks, or a role with clearly defined defaults and overrides. Never assume changing the inventory automatically selects the correct variable file.

---

## Lab 8: Validate Playbooks Before Execution

### Objective

Build a validation routine for your automation.

### Requirements

- Run a syntax check.
- Review the task list.
- Use check mode where supported.
- Review changes using diff mode.
- Execute the playbook.
- Verify the target system state.

### Commands

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --syntax-check
```

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --list-tasks
```

```bash
ansible-playbook -i inventory.ini nginx-setup.yml --check --diff
```

```bash
ansible-playbook -i inventory.ini nginx-setup.yml
```

Document any differences between predicted changes and actual results.

---

# 16. Troubleshooting Common Problems

## Problem 1: YAML Syntax Error

Example:

```text
ERROR! Syntax Error while loading YAML
```

### Possible Causes

- Incorrect indentation.
- Missing colon.
- Unclosed quotation marks.
- Incorrect list structure.
- Invalid YAML syntax.

### Solution

Review the relevant task and run:

```bash
ansible-playbook -i inventory.ini playbook.yml --syntax-check
```

---

## Problem 2: Permission Denied

Example:

```text
Permission denied
```

### Possible Causes

- The SSH user lacks access.
- The task writes to a protected directory.
- Privilege escalation is not enabled.
- The SSH key or file permissions are incorrect.

### Solution

Check connectivity:

```bash
ansible all -i inventory.ini -m ansible.builtin.ping
```

Use privilege escalation when appropriate:

```yaml
become: true
```

If required, prompt for the sudo password:

```bash
ansible-playbook -i inventory.ini playbook.yml -K
```

---

## Problem 3: Package Not Found

Example:

```text
No package matching 'nginx' is available
```

### Possible Causes

- Package repositories are not configured.
- Repository metadata is outdated.
- The package name differs across distributions.
- The managed host lacks network access.

### Solution

On Debian-based systems, consider refreshing package metadata:

```yaml
- name: Update package metadata
  ansible.builtin.apt:
    update_cache: true
```

On DNF-based systems, verify repository configuration and package availability.

---

## Problem 4: Service Failed to Start

### Possible Causes

- Invalid service configuration.
- Port conflicts.
- Missing files or directories.
- Incorrect file permissions.
- Package installation problems.

### Troubleshooting Commands

```bash
systemctl status nginx
```

```bash
journalctl -u nginx --no-pager -n 50
```

```bash
nginx -t
```

Use the commands appropriate to the service and operating system.

---

## Problem 5: Variable Is Undefined

Example:

```text
The task includes an option with an undefined variable
```

### Possible Causes

- The variable is misspelled.
- The variable file was not loaded.
- The variable is defined in a different scope.
- The variable is unavailable for the selected host.

### Solution

Inspect the relevant playbook and variable files. For optional values, use a default when appropriate:

```yaml
msg: "{{ app_environment | default('development') }}"
```

For required values, fail clearly instead of silently selecting an unsafe default.

---

## Problem 6: Check Mode Does Not Predict the Final Result

### Cause

Some modules and tasks cannot fully simulate their behavior in check mode.

### Solution

- Review module check-mode support.
- Test in a non-production environment.
- Avoid assuming a successful check-mode run guarantees successful execution.
- Validate the final state after a real run.

---

# 17. Ansible Playbook Best Practices

## 17.1 Prefer Idempotent Modules

Idempotency means that running the same automation repeatedly should not keep making unnecessary changes when the system is already in the desired state.

For example:

```yaml
- name: Ensure Nginx is installed
  ansible.builtin.package:
    name: nginx
    state: present
```

This describes the desired state rather than repeatedly issuing a raw installation command.

Prefer declarative modules such as `package`, `file`, `user`, and `service` when suitable.

## 17.2 Use Fully Qualified Module Names

Prefer:

```yaml
ansible.builtin.copy:
```

Instead of:

```yaml
copy:
```

Fully qualified collection names make module references explicit and improve clarity.

## 17.3 Use Meaningful Task Names

Avoid:

```yaml
- name: Task 1
```

Prefer:

```yaml
- name: Ensure Nginx is installed
```

Descriptive names make execution logs easier to understand.

## 17.4 Keep Secrets Out of Git

Never commit:

- Plaintext passwords.
- Private SSH keys.
- Cloud access keys.
- API tokens.
- Sensitive production configuration.

Use Ansible Vault or an approved secrets-management system for sensitive values.

## 17.5 Separate Variables From Logic

Use variable files for settings that differ across environments.

Keep common configuration reusable, and avoid duplicating entire playbooks for small differences.

## 17.6 Validate Before Production

Before running a playbook against production:

1. Review the inventory and host pattern.
2. Check syntax.
3. Review the task list.
4. Use check mode and diff mode where supported.
5. Test against representative hosts.
6. Confirm backups or rollback procedures for risky changes.
7. Verify results after execution.

## 17.7 Avoid Unnecessary Shell Commands

Use purpose-built modules wherever possible.

For example, use the `file` module to create directories instead of executing `mkdir`.

Modules usually provide better idempotency, clearer results, and easier error handling.

---

# 18. Suggested GitHub Repository Structure

Organize your Module 3 content like this:

```text
ansible-zero-to-hero/
└── module-03-yaml-playbooks-modules-variables-facts/
    ├── README.md
    ├── inventory.ini
    ├── first-playbook.yml
    ├── nginx-setup.yml
    ├── facts.yml
    ├── variables.yml
    ├── lab1.yml
    ├── lab5.yml
    ├── deploy.yml
    ├── group_vars/
    │   └── webservers.yml
    ├── host_vars/
    │   ├── web01.yml
    │   └── web02.yml
    ├── vars/
    │   ├── dev.yml
    │   └── prod.yml
    └── reports/
        └── .gitkeep
```

Example inventory:

```ini
[webservers]
web01 ansible_host=192.0.2.11
web02 ansible_host=192.0.2.12

[dbservers]
db01 ansible_host=192.0.2.21

[all:vars]
ansible_user=ansible
```

Replace the example addresses and SSH username with your actual lab configuration.

The `192.0.2.0/24` network is reserved for documentation, so these addresses are examples rather than real server addresses.

Do not commit private keys, passwords, or sensitive generated reports.

---

# 19. Module 3 Interview Questions

Use these questions to test your understanding.

### YAML

1. What is YAML?
2. Why does Ansible use YAML?
3. What is the difference between a list and a dictionary?
4. Why is indentation important?
5. How do you validate a playbook's syntax?

### Playbooks

6. What is an Ansible playbook?
7. What is the difference between a play and a task?
8. What does `hosts` define?
9. What is the purpose of `gather_facts`?
10. How do you run only selected tasks?
11. What is the purpose of `become`?
12. What is the difference between check mode and normal execution?
13. What is diff mode used for?

### Modules

14. What is an Ansible module?
15. What is the difference between `command` and `shell`?
16. When would you use `copy` instead of `template`?
17. What is the difference between `package`, `apt`, and `dnf`?
18. What is the purpose of the `file` module?
19. How do you create a Linux user using Ansible?
20. What is the difference between `service` and `systemd_service`?
21. When would you use `stat`?
22. What is the purpose of `assert` and `fail`?

### Variables and Facts

23. What is a variable in Ansible?
24. What is the difference between a variable and a fact?
25. How does `register` work?
26. What is the purpose of `ansible_os_family`?
27. What is a Jinja2 expression?
28. What does the `default` filter do?
29. What is variable precedence?
30. How can you maintain different configuration values for development and production?

### Practical Questions

31. How would you install Nginx on 20 servers?
32. How would you install packages on Debian and RHEL-family systems using one playbook?
33. How would you collect OS information from every server?
34. How would you create a user only on web servers?
35. How would you preview file changes before applying them?
36. How would you prevent a playbook from continuing when a required variable is missing?

Try to answer these questions without looking at the README, then implement the relevant examples yourself.

---

# 20. Module 3 Completion Checklist

Before moving to Module 4, make sure you can:

- [ ] Explain YAML lists, dictionaries, and key-value pairs.
- [ ] Write valid YAML without indentation errors.
- [ ] Create a playbook with multiple tasks.
- [ ] Execute a playbook against selected inventory groups.
- [ ] Install packages using Ansible modules.
- [ ] Create files and directories with correct permissions.
- [ ] Manage Linux users and groups.
- [ ] Start, stop, and enable services.
- [ ] Explain the difference between `command` and `shell`.
- [ ] Register task results and inspect command output.
- [ ] Gather and use system facts.
- [ ] Define variables in playbooks and external files.
- [ ] Use conditions to control task execution.
- [ ] Apply tags to selected tasks.
- [ ] Use `become` for privileged operations.
- [ ] Validate playbooks using syntax checks.
- [ ] Understand the limitations of check mode.
- [ ] Use diff mode carefully.
- [ ] Troubleshoot common playbook failures.
- [ ] Complete all eight hands-on labs.

---

# 21. Final Outcome

After completing Module 3, you should be able to write structured Ansible playbooks that automate repeatable Linux administration tasks across multiple servers.

You will understand how to:

- Describe desired system configurations in YAML.
- Use modules instead of relying on manual shell commands.
- Reuse variables and system facts.
- Apply conditions and tags.
- Capture task output and validate results.
- Test automation before making changes.
- Organize automation code for a GitHub portfolio.

**The goal is not just to execute commands remotely. The goal is to define, validate, and maintain the desired state of your Linux infrastructure through reusable automation.**

