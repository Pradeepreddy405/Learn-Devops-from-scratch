# Module 2: Inventory Management and Ad Hoc Commands

## Ansible Zero to Hero — Cloud & DevOps Engineering

Welcome to Module 2 of **Ansible Zero to Hero**.

In Module 1, you learned Ansible fundamentals, architecture, installation, SSH authentication, and configuration.

In this module, you will learn how to organize hundreds of servers using inventories and execute administrative operations across multiple machines using Ansible ad hoc commands.

These skills are essential for Linux administration, AWS Cloud, DevOps, SRE, and Platform Engineering.

---

## Table of Contents

1. [Learning Objectives](#1-learning-objectives)
2. [What Is an Ansible Inventory?](#2-what-is-an-ansible-inventory)
3. [Static Inventory](#3-static-inventory)
4. [INI Inventory Format](#4-ini-inventory-format)
5. [YAML Inventory Format](#5-yaml-inventory-format)
6. [Hosts, Groups, and Child Groups](#6-hosts-groups-and-child-groups)
7. [Host Variables and Group Variables](#7-host-variables-and-group-variables)
8. [Inventory Aliases](#8-inventory-aliases)
9. [Development, Staging, and Production Inventories](#9-development-staging-and-production-inventories)
10. [Inventory Patterns and Host Selection](#10-inventory-patterns-and-host-selection)
11. [Dynamic Inventory](#11-dynamic-inventory)
12. [What Are Ad Hoc Commands?](#12-what-are-ad-hoc-commands)
13. [Ad Hoc Command Syntax](#13-ad-hoc-command-syntax)
14. [Common Modules Used with Ad Hoc Commands](#14-common-modules-used-with-ad-hoc-commands)
15. [Remote Command Execution](#15-remote-command-execution)
16. [Privilege Escalation](#16-privilege-escalation)
17. [Parallel Execution and Forks](#17-parallel-execution-and-forks)
18. [Return Codes and Command Output](#18-return-codes-and-command-output)
19. [Important Inventory Commands](#19-important-inventory-commands)
20. [Hands-On Labs](#20-hands-on-labs)
21. [Troubleshooting](#21-troubleshooting)
22. [Security Best Practices](#22-security-best-practices)
23. [Real-World Scenarios](#23-real-world-scenarios)
24. [Interview Questions and Answers](#24-interview-questions-and-answers)
25. [Knowledge Assessment](#25-knowledge-assessment)
26. [Module Completion Checklist](#26-module-completion-checklist)
27. [References](#27-references)

---

# 1. Learning Objectives

By the end of this module, you should be able to:

- Explain the purpose of an Ansible inventory.
- Create static inventories using INI and YAML.
- Organize servers into logical groups.
- Create parent and child groups.
- Define host variables and group variables.
- Configure inventory aliases.
- Separate development, staging, and production environments.
- Select hosts using inventory patterns.
- Understand the purpose of dynamic inventory.
- Execute ad hoc commands against individual hosts and groups.
- Use common Ansible modules.
- Collect server health information.
- Install packages and manage services remotely.
- Execute commands with privilege escalation.
- Control parallel execution using forks.
- Interpret Ansible return codes and task results.
- Troubleshoot inventory parsing and unreachable hosts.

## Prerequisites

Before starting this module, you should understand:

- Linux fundamentals.
- SSH connectivity.
- Ansible installation.
- Ansible control nodes and managed nodes.
- Basic YAML syntax.
- Basic Ansible commands.

You should have access to at least two Linux managed nodes for initial practice.

The final lab uses five managed nodes.

---

# 2. What Is an Ansible Inventory?

An **Ansible inventory is a collection of hosts and groups that Ansible can target for automation**.

An inventory tells Ansible which machines are available and can also define connection information and variables for those machines.

Imagine that you are a DevOps engineer managing 100 Linux servers.

Your infrastructure might contain:

- 20 web servers.
- 30 application servers.
- 10 database servers.
- 20 development servers.
- 10 staging servers.
- 10 production utility servers.

Connecting to each machine individually would be inefficient.

Ansible inventories allow you to organize these machines logically and execute automation against selected hosts.

## 2.1 Without an Inventory

```text
Engineer
   |
   +---- SSH ----> Server 1
   |
   +---- SSH ----> Server 2
   |
   +---- SSH ----> Server 3
   |
   +---- SSH ----> Server 4
```

The engineer must repeatedly identify and connect to each server.

## 2.2 With an Inventory

```text
                 Ansible Control Node
                          |
                          v
                     Inventory
                          |
             +------------+------------+
             |            |            |
             v            v            v
         Web Servers   App Servers   DB Servers
             |            |            |
             v            v            v
         web01,02      app01,02      db01,02
```

Ansible can target one host, an entire group, or a combination of groups.

## 2.3 What Information Can an Inventory Contain?

An inventory can define:

- Hostnames.
- IP addresses.
- Host aliases.
- Groups.
- Parent and child group relationships.
- SSH usernames.
- SSH ports.
- Connection settings.
- Host-specific variables.
- Group-specific variables.
- References to dynamic inventory sources.

Inventories can be static files or dynamically generated from external systems.

## 2.4 Common Inventory Types

| Inventory type | Description | Example |
|---|---|---|
| Static INI | Hosts and groups in INI format | `hosts.ini` |
| Static YAML | Hosts and groups in YAML format | `hosts.yml` |
| Dynamic inventory | Hosts discovered from an external source | AWS EC2 |
| Multiple-source inventory | Combines supported inventory sources | Static files plus a cloud inventory plugin |

---

# 3. Static Inventory

## 3.1 What Is a Static Inventory?

A static inventory is a file in which hosts and groups are explicitly defined.

For example:

```ini
[webservers]
192.168.1.101
192.168.1.102

[appservers]
192.168.1.103
192.168.1.104
```

Here:

- `webservers` is a group.
- `appservers` is another group.
- Each IP address represents a managed host.

Ansible reads these definitions and uses them to determine which machines to target.

## 3.2 When Should You Use Static Inventories?

Static inventories are useful when:

- Learning Ansible.
- Managing a small, stable environment.
- Working with local virtual machines.
- Automating a fixed set of servers.
- Maintaining a controlled lab environment.

For larger cloud environments, manually updating the inventory may become inconvenient. Dynamic inventory can help address that problem.

## 3.3 Create a Static Inventory

Create a project directory:

```bash
mkdir -p ~/ansible-module-02/inventory
cd ~/ansible-module-02
```

Create the inventory:

```bash
nano inventory/hosts.ini
```

Add:

```ini
[webservers]
192.168.1.101
192.168.1.102

[appservers]
192.168.1.103
192.168.1.104

[databases]
192.168.1.105
```

Replace the sample IP addresses with your actual managed node addresses.

## 3.4 Inspect the Inventory

Display the parsed inventory:

```bash
ansible-inventory -i inventory/hosts.ini --list
```

Display its group hierarchy:

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

List the hosts that Ansible can target:

```bash
ansible all -i inventory/hosts.ini --list-hosts
```

These commands help verify the inventory before running automation.

---

# 4. INI Inventory Format

INI is a simple text format that uses section headers to organize hosts and groups.

## 4.1 Basic INI Inventory

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[appservers]
app01 ansible_host=192.168.1.103
app02 ansible_host=192.168.1.104
```

### Explanation

`[webservers]` creates a group called `webservers`.

`web01` is an inventory hostname.

`ansible_host=192.168.1.101` specifies the address Ansible should connect to for that inventory hostname.

The inventory hostname and the actual connection address do not need to be identical.

## 4.2 Define a Default Remote User

```ini
[all:vars]
ansible_user=automation
```

This defines a variable for all hosts in the inventory.

Ansible uses the `automation` account as the default remote SSH username unless a higher-precedence applicable setting overrides it.

## 4.3 Define a Different SSH Port

```ini
[webservers]
web01 ansible_host=192.168.1.101 ansible_port=2222
```

This example tells Ansible to connect to `web01` using TCP port `2222`.

Use the actual SSH port configured on your managed node.

## 4.4 Complete Example

```ini
[webservers]
web01 ansible_host=192.168.1.101 ansible_user=automation
web02 ansible_host=192.168.1.102 ansible_user=automation

[appservers]
app01 ansible_host=192.168.1.103 ansible_user=automation
app02 ansible_host=192.168.1.104 ansible_user=automation

[databases]
db01 ansible_host=192.168.1.105 ansible_user=automation

[all:vars]
ansible_python_interpreter=auto_silent
```

The `ansible_python_interpreter` example uses an interpreter discovery setting supported by applicable Ansible versions. You generally do not need to specify it unless you have a reason to customize interpreter discovery.

## 4.5 Validate the Inventory

```bash
ansible-inventory -i inventory/hosts.ini --list
```

If the inventory contains syntax errors or unsupported definitions, Ansible may report a parsing failure or warnings.

Always validate new inventory files before using them in important automation.

---

# 5. YAML Inventory Format

YAML is another supported format for defining static inventories.

It is particularly useful when the inventory has nested groups, variables, and structured configuration.

## 5.1 Basic YAML Inventory

Create a file:

```bash
nano inventory/hosts.yml
```

Add:

```yaml
---
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: 192.168.1.101
        web02:
          ansible_host: 192.168.1.102

    appservers:
      hosts:
        app01:
          ansible_host: 192.168.1.103
        app02:
          ansible_host: 192.168.1.104
```

## 5.2 Understanding the Structure

| YAML element | Purpose |
|---|---|
| `all` | Root group containing all inventory hosts |
| `children` | Defines groups nested under a parent |
| `webservers` | A group containing web servers |
| `hosts` | Lists the hosts in a group |
| `web01` | Inventory hostname |
| `ansible_host` | Address used for the connection |

YAML indentation is significant. Use consistent indentation, typically two spaces per nesting level.

## 5.3 Add Group Variables

```yaml
---
all:
  children:
    webservers:
      hosts:
        web01:
          ansible_host: 192.168.1.101
        web02:
          ansible_host: 192.168.1.102

      vars:
        ansible_user: automation
        app_port: 8080
```

The variables under `webservers.vars` apply to hosts in that group unless overridden by applicable higher-precedence values.

## 5.4 Add Child Groups

```yaml
---
all:
  children:
    production:
      children:
        webservers:
          hosts:
            web01:
              ansible_host: 192.168.1.101

        appservers:
          hosts:
            app01:
              ansible_host: 192.168.1.103
```

Here, `production` is a parent group, and `webservers` and `appservers` are child groups.

## 5.5 Validate YAML Inventory

```bash
ansible-inventory -i inventory/hosts.yml --list
```

Display the hierarchy:

```bash
ansible-inventory -i inventory/hosts.yml --graph
```

## 5.6 INI vs YAML Inventory

| Feature | INI | YAML |
|---|---|---|
| Readability | Simple for small inventories | Clear for structured inventories |
| Variables | Often written inline | Nested variable structures |
| Parent and child groups | Supported | Supported |
| Large structured inventories | Can become harder to maintain | Often easier to organize |
| Indentation sensitivity | Low | High |
| Common file extensions | `.ini`, `.txt` | `.yml`, `.yaml` |

Both formats are valid. Choose the format that best suits the complexity and conventions of your project.

---

# 6. Hosts, Groups, and Child Groups

## 6.1 What Is a Host?

A host is an individual machine that Ansible can target.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101
```

Here, `web01` identifies the host in the inventory.

## 6.2 What Is a Group?

A group is a collection of hosts.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102
web03 ansible_host=192.168.1.103
```

Now, all three hosts belong to the `webservers` group.

You can execute a command against the group:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping
```

Ansible targets the hosts that belong to that group.

## 6.3 What Is a Parent Group?

A parent group contains child groups.

This allows you to organize infrastructure at different levels.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[appservers]
app01 ansible_host=192.168.1.103

[production:children]
webservers
appservers
```

The `production` group contains both `webservers` and `appservers`.

Running a command against `production` targets the hosts in those child groups.

```bash
ansible production -i inventory/hosts.ini -m ansible.builtin.ping
```

## 6.4 Group Hierarchy

```text
all
 |
 +---- production
 |        |
 |        +---- webservers
 |        |       |
 |        |       +---- web01
 |        |       +---- web02
 |        |
 |        +---- appservers
 |                |
 |                +---- app01
 |
 +---- development
          |
          +---- dev-webservers
```

This structure makes it easier to target infrastructure by environment and application role.

## 6.5 Why Use Groups?

Groups help you:

- Target specific server roles.
- Apply common variables.
- Separate environments.
- Execute maintenance operations in batches.
- Reduce repeated host definitions.
- Organize automation for larger environments.

## 6.6 Important Note About Group Membership

A host can belong to more than one group.

For example, `web01` might belong to both:

- `webservers`
- `production`

This is useful when you want to target machines by either their technical role or their environment.

---

# 7. Host Variables and Group Variables

Variables let you define values that differ between hosts, groups, and environments.

They reduce repetition and help make automation reusable.

## 7.1 What Are Host Variables?

Host variables apply to a particular host.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101 app_port=8080
web02 ansible_host=192.168.1.102 app_port=8081
```

Here:

- `web01` uses port `8080`.
- `web02` uses port `8081`.

You can inspect the resolved inventory:

```bash
ansible-inventory -i inventory/hosts.ini --host web01
```

## 7.2 What Are Group Variables?

Group variables apply to members of a group.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[webservers:vars]
ansible_user=automation
app_port=8080
```

Both hosts inherit these group variables unless an applicable override changes their values.

## 7.3 Use Separate Variable Files

A recommended project structure is:

```text
ansible-project/
├── ansible.cfg
├── inventory/
│   └── hosts.ini
├── group_vars/
│   └── webservers.yml
├── host_vars/
│   └── web01.yml
└── playbooks/
    └── site.yml
```

For this layout, the variable directories are at the project root.

Ansible automatically loads `group_vars` and `host_vars` from supported locations associated with the inventory or playbook, depending on the execution context.

For predictable behavior, keep variable directories in a documented project structure and verify the resolved variables.

## 7.4 Example Group Variables

Create:

`group_vars/webservers.yml`

```yaml
---
ansible_user: automation
app_port: 8080
nginx_enabled: true
```

These values apply to the `webservers` group.

## 7.5 Example Host Variables

Create:

`host_vars/web01.yml`

```yaml
---
app_port: 8081
server_role: primary
```

These values provide host-specific configuration for `web01`.

When applicable, host-specific variables take precedence over group variables for the same variable name, subject to Ansible's broader variable-precedence rules.

## 7.6 Inspect Variables

Use:

```bash
ansible-inventory -i inventory/hosts.ini --host web01
```

To inspect the complete inventory data:

```bash
ansible-inventory -i inventory/hosts.ini --list
```

These commands help identify which inventory variables have been resolved.

For playbook variables and complex precedence issues, inspect the relevant playbook, variable sources, and Ansible variable-precedence documentation.

---

# 8. Inventory Aliases

## 8.1 What Is an Inventory Alias?

An inventory alias is a name used to identify a host independently of its IP address or DNS hostname.

Example:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102
```

Here:

- `web01` is the inventory alias.
- `192.168.1.101` is the connection address.

You can target the host using its inventory name:

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping
```

## 8.2 Why Are Aliases Useful?

Suppose your cloud server has a changing IP address.

Instead of repeatedly changing the name used in your automation, you can keep a stable inventory alias and update the connection address.

Example:

```ini
[production]
payment-api-01 ansible_host=10.0.1.15
payment-api-02 ansible_host=10.0.1.16
```

The aliases communicate the purpose of each machine.

## 8.3 Alias with a Custom SSH Port

```ini
[webservers]
web01 ansible_host=192.168.1.101 ansible_port=2222
```

## 8.4 Alias with a Specific SSH User

```ini
[webservers]
web01 ansible_host=192.168.1.101 ansible_user=automation
```

## 8.5 Alias Best Practices

Use names that communicate:

- Application role.
- Environment.
- Region, where useful.
- Server purpose.
- Instance identity.

Avoid ambiguous names such as `server1` and `server2` in larger projects.

---

# 9. Development, Staging, and Production Inventories

Real-world infrastructure is usually separated into environments.

A common model contains:

- Development.
- Staging.
- Production.

Each environment may have different servers, variables, permissions, and deployment rules.

## 9.1 Why Separate Environments?

Development environments are commonly used for experimentation.

Staging environments help validate changes before production.

Production environments serve real users and require stricter controls.

Automation should target the intended environment explicitly.

## 9.2 Example Directory Structure

```text
ansible-project/
├── ansible.cfg
├── inventory/
│   ├── dev/
│   │   └── hosts.ini
│   ├── staging/
│   │   └── hosts.ini
│   └── prod/
│       └── hosts.ini
└── playbooks/
    └── deploy.yml
```

## 9.3 Development Inventory

`inventory/dev/hosts.ini`

```ini
[webservers]
dev-web01 ansible_host=192.168.10.101
dev-web02 ansible_host=192.168.10.102

[webservers:vars]
ansible_user=automation
environment=development
```

## 9.4 Staging Inventory

`inventory/staging/hosts.ini`

```ini
[webservers]
stg-web01 ansible_host=192.168.20.101
stg-web02 ansible_host=192.168.20.102

[webservers:vars]
ansible_user=automation
environment=staging
```

## 9.5 Production Inventory

`inventory/prod/hosts.ini`

```ini
[webservers]
prod-web01 ansible_host=10.0.1.101
prod-web02 ansible_host=10.0.1.102

[webservers:vars]
ansible_user=automation
environment=production
```

All addresses are examples.

## 9.6 Execute Against Development

```bash
ansible all -i inventory/dev/hosts.ini -m ansible.builtin.ping
```

## 9.7 Execute Against Staging

```bash
ansible all -i inventory/staging/hosts.ini -m ansible.builtin.ping
```

## 9.8 Execute Against Production

```bash
ansible all -i inventory/prod/hosts.ini -m ansible.builtin.ping
```

Before making changes in production, verify the selected inventory and hosts.

## 9.9 Production Safety

Use safeguards such as:

- Explicit production inventories.
- Code review.
- CI/CD approval gates.
- Restricted credentials.
- Staged rollout.
- Backups where appropriate.
- Health checks.
- Rollback procedures.

Do not assume that a correct inventory alone prevents accidental production changes.

---

# 10. Inventory Patterns and Host Selection

Inventory patterns control which hosts Ansible targets.

They are important because running a command against the wrong hosts can cause unnecessary downtime or configuration changes.

## 10.1 Target All Hosts

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

`all` targets all hosts in the selected inventory.

## 10.2 Target One Host

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping
```

## 10.3 Target a Group

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping
```

## 10.4 Target Multiple Groups

```bash
ansible 'webservers,appservers' -i inventory/hosts.ini -m ansible.builtin.ping
```

The comma-separated pattern selects the union of the named groups.

## 10.5 Exclude a Group

```bash
ansible 'all:!databases' -i inventory/hosts.ini -m ansible.builtin.ping
```

This targets hosts in `all` while excluding hosts in `databases`.

## 10.6 Intersect Groups

```bash
ansible 'production:&webservers' -i inventory/hosts.ini -m ansible.builtin.ping
```

This selects hosts that belong to both `production` and `webservers`.

## 10.7 Combine Inclusion and Exclusion

```bash
ansible 'production:!databases' -i inventory/hosts.ini -m ansible.builtin.ping
```

This selects production hosts while excluding database hosts.

## 10.8 Limit Hosts During Playbook Execution

Suppose your inventory contains 20 web servers, but you want to execute a playbook against only `web01`.

```bash
ansible-playbook -i inventory/hosts.ini playbooks/site.yml --limit web01
```

The `--limit` option restricts the playbook to the selected hosts within its inventory selection.

## 10.9 Preview the Selected Hosts

Before executing an operation, list the target hosts:

```bash
ansible 'production:!databases' -i inventory/hosts.ini --list-hosts
```

This is particularly useful before production maintenance.

## 10.10 Important Pattern Notes

- Quote complex patterns to prevent shell interpretation.
- Use the correct inventory.
- Verify the selected hosts.
- Remember that a playbook's `hosts` pattern and the command-line `--limit` option both affect the final target set.
- Do not run destructive operations against `all` without understanding the consequences.

For complete pattern syntax, see the official Ansible inventory guide.

---

# 11. Dynamic Inventory

## 11.1 What Is Dynamic Inventory?

A dynamic inventory obtains host information from an external source rather than relying exclusively on a manually maintained host list.

Sources can include:

- AWS EC2.
- Other supported cloud providers.
- Infrastructure management systems.
- Custom inventory scripts or plugins.
- External systems that expose inventory information.

## 11.2 Why Is Dynamic Inventory Useful?

Suppose your organization runs 200 EC2 instances.

New instances are created regularly, and terminated instances should no longer appear in the active inventory.

A manually maintained inventory can become outdated.

A dynamic inventory source can discover current instances and organize them using supported filters and grouping rules.

## 11.3 Static vs Dynamic Inventory

| Feature | Static inventory | Dynamic inventory |
|---|---|---|
| Host definitions | Manually maintained | Obtained from an external source |
| Updating hosts | Edit inventory files | Discover hosts through the configured source |
| Best for | Stable, smaller environments | Frequently changing infrastructure |
| Cloud integration | Possible but often manual | Can use cloud inventory plugins |
| Setup complexity | Usually low | Depends on the source and authentication |
| Dependencies | Inventory file | Plugin, credentials, dependencies, and access to the source |

## 11.4 AWS EC2 Dynamic Inventory

For AWS, Ansible supports an EC2 inventory plugin through the `amazon.aws` collection.

A simplified setup involves:

1. Installing the required collection.
2. Installing the dependencies required by that plugin.
3. Configuring AWS authentication.
4. Defining an inventory source.
5. Querying EC2 instances.
6. Grouping and filtering instances.
7. Testing the discovered inventory.

Install the collection:

```bash
ansible-galaxy collection install amazon.aws
```

The collection and its dependencies must be compatible with your Ansible installation.

Configure AWS authentication using an approved method, such as an appropriate IAM role or credentials provider.

Avoid placing AWS secret access keys directly in the inventory file.

## 11.5 Example AWS Inventory Source

Create `inventory/aws_ec2.yml`:

```yaml
---
plugin: amazon.aws.aws_ec2

regions:
  - ap-south-1

keyed_groups:
  - key: tags.Environment
    prefix: env
  - key: tags.Role
    prefix: role

hostnames:
  - private-ip-address

filters:
  instance-state-name: running
```

This is an illustrative starting point. Validate the supported plugin options against the version of the installed `amazon.aws` collection.

The configuration:

- Queries the specified AWS region.
- Discovers running instances.
- Creates groups based on selected EC2 tags.
- Uses private IP addresses as inventory hostnames.

For example, instances tagged with `Environment=production` may be grouped under a generated name based on the configured prefix.

## 11.6 Query Dynamic Inventory

```bash
ansible-inventory -i inventory/aws_ec2.yml --list
```

Display the group hierarchy:

```bash
ansible-inventory -i inventory/aws_ec2.yml --graph
```

If authentication, permissions, dependencies, or plugin configuration are incorrect, inventory discovery may fail.

## 11.7 When Should You Learn Dynamic Inventory?

Learn the basics now, but develop a full cloud inventory workflow after understanding:

- Static inventories.
- Variables.
- Inventory patterns.
- SSH authentication.
- AWS IAM.
- Ansible collections.

These foundations make dynamic inventory much easier to troubleshoot.

---

# 12. What Are Ad Hoc Commands?

An **Ansible ad hoc command is a one-time command used to perform an operation on selected managed hosts without creating a playbook**.

Ad hoc commands are useful for quick administrative tasks.

Examples include:

- Checking server uptime.
- Collecting disk utilization.
- Checking memory.
- Testing connectivity.
- Installing packages.
- Managing services.
- Copying files.
- Creating directories.
- Creating users.

## 12.1 Example

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

This tests Ansible connectivity to all hosts in the inventory.

## 12.2 Ad Hoc Commands vs Playbooks

| Feature | Ad hoc command | Playbook |
|---|---|---|
| Structure | Single command invocation | YAML file with plays and tasks |
| Best use | Quick administrative operations | Repeatable workflows |
| Reusability | Limited unless documented or scripted | High |
| Complex logic | Awkward for complex workflows | Better suited |
| Version control | Command can be documented or scripted | Playbooks can be version-controlled |
| Example | Check uptime on all hosts | Configure an entire application stack |

Ad hoc commands are useful, but do not use long sequences of unrelated commands as a replacement for maintainable playbooks.

---

# 13. Ad Hoc Command Syntax

The general syntax is:

```bash
ansible <pattern> -i <inventory> -m <module> -a "<arguments>"
```

## 13.1 Explanation

| Component | Meaning |
|---|---|
| `ansible` | Command-line tool |
| `<pattern>` | Hosts to target |
| `-i` | Specifies an inventory source |
| `<inventory>` | Inventory file or source |
| `-m` | Selects the module |
| `<module>` | Module to execute |
| `-a` | Passes module arguments |

## 13.2 Example: Test Connectivity

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

## 13.3 Example: Check Uptime

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

## 13.4 Example: Check Disk Utilization

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

## 13.5 Example: Check Memory

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "free -h"
```

## 13.6 Example: Check the Operating System

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "cat /etc/os-release"
```

## 13.7 Increase Verbosity

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping -vvv
```

Verbose output can help diagnose SSH, connection, and execution issues. Be careful when sharing verbose logs because they may contain sensitive operational information.

---

# 14. Common Modules Used with Ad Hoc Commands

Ansible modules provide structured ways to perform operations on managed nodes.

## 14.1 Ping Module

Purpose: Test Ansible connectivity.

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

The module checks whether Ansible can execute successfully on the remote host. It is not an ICMP ping.

## 14.2 Command Module

Purpose: Execute a command without shell processing.

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

Use this for simple commands that do not require shell features such as pipes, redirection, or shell variable expansion.

## 14.3 Shell Module

Purpose: Execute a command through a shell.

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.shell -a "df -h | grep -v tmpfs"
```

Use the shell module when shell-specific features are required.

Prefer a dedicated Ansible module when one can perform the operation safely and directly.

## 14.4 File Module

Purpose: Manage files, directories, and permissions.

Create a directory:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.file -a "path=/opt/application state=directory mode=0755" -b
```

Create an empty file:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.file -a "path=/opt/application/status.txt state=touch" -b
```

## 14.5 Copy Module

Purpose: Copy a local file from the control node to managed nodes.

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.copy -a "src=./message.txt dest=/tmp/message.txt"
```

The source file must exist on the control node.

## 14.6 Package Module

Purpose: Manage software packages using the appropriate package manager.

Install Nginx:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.package -a "name=nginx state=present" -b
```

Remove Nginx:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.package -a "name=nginx state=absent" -b
```

Package names and package-manager availability depend on the target operating system.

## 14.7 Service Module

Purpose: Manage services.

Ensure Nginx is running:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.service -a "name=nginx state=started" -b
```

Stop Nginx:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.service -a "name=nginx state=stopped" -b
```

Enable Nginx at boot:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.service -a "name=nginx enabled=true" -b
```

Stopping a production service can interrupt application traffic. Verify the target group before executing service changes.

## 14.8 User Module

Create a user:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.user -a "name=devops state=present" -b
```

Remove a user:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.user -a "name=devops state=absent remove=false" -b
```

The removal command does not request deletion of the user's files. Review the consequences before changing account state on production systems.

## 14.9 Group Module

Create a group:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.group -a "name=developers state=present" -b
```

## 14.10 Stat Module

Purpose: Inspect a file or directory.

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.stat -a "path=/etc/nginx/nginx.conf"
```

This returns structured information about the file, including whether it exists.

## 14.11 Debug Module

Purpose: Display a message or value.

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.debug -a "msg='Ansible connectivity verified'"
```

This is helpful for testing and inspecting simple values.

## 14.12 Command vs Shell

| Feature | `ansible.builtin.command` | `ansible.builtin.shell` |
|---|---|---|
| Shell processing | No | Yes |
| Pipes | Not interpreted by a shell | Supported |
| Redirection | Not interpreted by a shell | Supported |
| Shell variable expansion | No shell expansion | Supported |
| Security considerations | Generally preferable for simple commands | Requires more care with untrusted input |
| Recommended use | Simple command execution | Operations requiring shell features |

**Best practice:** Use state-aware modules such as `package`, `file`, `user`, and `service` for configuration management. Use `command` or `shell` when necessary.

---

# 15. Remote Command Execution

Ansible allows you to execute commands on remote machines from the control node.

## 15.1 Check Uptime

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

This collects uptime information from each selected host.

## 15.2 Check Disk Utilization

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

This displays mounted filesystems and their capacity utilization.

## 15.3 Check Memory

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "free -h"
```

## 15.4 Check CPU Information

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "nproc"
```

This reports the number of processing units available to the command.

## 15.5 Check Operating System Information

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "cat /etc/os-release"
```

## 15.6 Collect Multiple Metrics

You can run separate commands:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "free -h"
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

For a repeatable health report, use a playbook with structured tasks and fact gathering rather than manually issuing many commands.

## 15.7 Important Operational Considerations

Remote commands may:

- Fail if the executable is unavailable.
- Return nonzero exit codes.
- Require elevated permissions.
- Produce different output on different operating systems.
- Depend on environment variables or shell behavior.

Always verify the output before making operational decisions.

---

# 16. Privilege Escalation

Some operations require administrative privileges.

For example:

- Installing packages.
- Changing system files.
- Managing system services.
- Creating system users.
- Modifying firewall rules.

Ansible supports privilege escalation using `become`.

## 16.1 Use `-b`

Example:

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.package -a "name=nginx state=present"
```

Here:

- `-b` enables privilege escalation.
- `package` manages the package.
- `state=present` requests that the package be installed.

## 16.2 Prompt for the Become Password

```bash
ansible webservers -i inventory/hosts.ini -b -K -m ansible.builtin.package -a "name=nginx state=present"
```

Ansible prompts for the password required for privilege escalation.

## 16.3 Run as a Specific User

For applicable Linux operations, you can select the user to become:

```bash
ansible webservers -i inventory/hosts.ini -b --become-user root -m ansible.builtin.command -a "whoami"
```

The remote account must have the required permissions.

## 16.4 Least-Privilege Principle

Do not use privilege escalation unnecessarily.

For example, checking uptime usually does not require root privileges.

Installing system packages typically does.

Choose the appropriate privileges for each operation.

---

# 17. Parallel Execution and Forks

Ansible can execute operations on multiple hosts concurrently.

The `forks` setting controls the maximum number of parallel worker processes used for applicable operations.

## 17.1 Example

Suppose your inventory contains 50 servers.

Running a task against all of them does not necessarily mean Ansible processes every host simultaneously.

The effective parallelism depends on settings such as `forks`, the number of targeted hosts, and other execution constraints.

## 17.2 Set Forks on the Command Line

```bash
ansible all -i inventory/hosts.ini -f 20 -m ansible.builtin.ping
```

Here, `-f 20` sets the fork count to 20 for that command.

## 17.3 Configure Forks in ansible.cfg

```ini
[defaults]
forks = 20
```

This establishes the default fork setting for commands using the selected configuration.

## 17.4 How Forks Affect Execution

| Fork setting | General behavior |
|---|---|
| `forks = 1` | Very limited parallel execution |
| `forks = 5` | Up to five worker processes for applicable operations |
| `forks = 20` | Higher potential parallelism |
| `forks = 50` | Higher resource demand and potential concurrency |

These are illustrative settings, not performance guarantees.

## 17.5 Choosing an Appropriate Value

Consider:

- Number of managed hosts.
- Control node CPU and memory.
- Network capacity.
- SSH connection limits.
- Managed node resource limits.
- Whether the operation is safe to execute concurrently.
- API rate limits for external systems.

Higher fork counts do not automatically make automation faster.

For production changes, the correct execution strategy may be more important than maximizing concurrency.

---

# 18. Return Codes and Command Output

Understanding task results helps you determine whether automation succeeded.

## 18.1 Common Ansible Results

| Result | Meaning |
|---|---|
| `ok` | Task completed without reporting a change |
| `changed` | Task changed the managed state or reported a change |
| `failed` | Task failed |
| `unreachable` | Ansible could not reach the host |
| `skipped` | Task was not executed |

## 18.2 Example Successful Command

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

Illustrative output:

```text
web01 | CHANGED | rc=0 >>
 15:00:00 up 10 days,  2:10,  1 user,  load average: 0.20, 0.18, 0.15
```

A successful `command` task may report `changed` because Ansible generally cannot determine whether an arbitrary command changed system state.

This does not mean the server configuration necessarily changed.

## 18.3 What Is rc?

`rc` stands for return code, also commonly called an exit status.

For Unix-like commands, a return code of `0` generally indicates success, while a nonzero code generally indicates an error or another condition defined by the command.

The exact meaning of a nonzero value depends on the command.

## 18.4 Example Failed Command

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.command -a "this-command-does-not-exist"
```

The task should fail because the executable cannot be found.

The exact return code and error message can vary.

## 18.5 Check the Exit Status of an Ansible Command

For example:

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping

echo $?
```

The shell's `$?` contains the exit status of the immediately preceding command.

Do not run another command before checking it, or you will inspect the wrong status.

## 18.6 Understand Standard Output and Standard Error

Many modules return information such as:

- `stdout`: Standard output.
- `stderr`: Standard error.
- `rc`: Return code.
- `stdout_lines`: Standard output split into lines.
- `stderr_lines`: Standard error split into lines.

These fields depend on the module and the command executed.

## 18.7 Idempotency and Ad Hoc Commands

Not all ad hoc commands are idempotent.

For example:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.shell -a "echo hello >> /tmp/demo.txt"
```

Running this repeatedly appends more text to the file.

By contrast:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.file -a "path=/tmp/demo-directory state=directory"
```

The second operation requests a directory's presence, which is a more appropriate configuration-management operation.

Use state-aware modules when possible.

---

# 19. Important Inventory Commands

These commands should become part of your regular Ansible workflow.

## 19.1 Display Inventory as JSON

```bash
ansible-inventory -i inventory/hosts.ini --list
```

Use this to inspect the parsed inventory structure and resolved inventory variables.

## 19.2 Display Group Hierarchy

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

Use this to verify parent groups, child groups, and host membership.

## 19.3 List All Target Hosts

```bash
ansible all -i inventory/hosts.ini --list-hosts
```

This previews the hosts selected by the pattern.

## 19.4 Test Connectivity

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.ping
```

## 19.5 Check Uptime

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

## 19.6 Check Disk Usage

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

## 19.7 Inspect One Host

```bash
ansible-inventory -i inventory/hosts.ini --host web01
```

## 19.8 Test with Verbose Output

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping -vvv
```

---

# 20. Hands-On Labs

Complete these seven labs before moving to Module 3.

All IP addresses and usernames below are examples. Replace them with your actual lab details.

## Lab 1: Create an Inventory Containing Five Linux Servers

### Objective

Create an inventory containing five managed hosts.

### Step 1: Create the Directory

```bash
mkdir -p ~/ansible-module-02/inventory
cd ~/ansible-module-02
```

### Step 2: Create the Inventory

Create `inventory/hosts.ini`:

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[appservers]
app01 ansible_host=192.168.1.103
app02 ansible_host=192.168.1.104

[databases]
db01 ansible_host=192.168.1.105

[all:vars]
ansible_user=automation
```

### Step 3: Validate the Inventory

```bash
ansible-inventory -i inventory/hosts.ini --list
```

### Step 4: Display the Hierarchy

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

### Step 5: List the Hosts

```bash
ansible all -i inventory/hosts.ini --list-hosts
```

### Expected Result

Ansible should recognize five inventory hosts.

Connectivity is not tested by these inventory commands. You will test connectivity in the next lab.

---

## Lab 2: Group Servers by Application Role

### Objective

Organize the five hosts into web, application, and database groups.

### Inventory

```ini
[webservers]
web01 ansible_host=192.168.1.101
web02 ansible_host=192.168.1.102

[appservers]
app01 ansible_host=192.168.1.103
app02 ansible_host=192.168.1.104

[databases]
db01 ansible_host=192.168.1.105

[production:children]
webservers
appservers
databases

[all:vars]
ansible_user=automation
```

### Tasks

List web servers:

```bash
ansible webservers -i inventory/hosts.ini --list-hosts
```

List application servers:

```bash
ansible appservers -i inventory/hosts.ini --list-hosts
```

List production servers:

```bash
ansible production -i inventory/hosts.ini --list-hosts
```

### Expected Result

- `webservers` selects two hosts.
- `appservers` selects two hosts.
- `databases` selects one host.
- `production` selects all five hosts through its child groups.

---

## Lab 3: Execute Commands Against Specific Groups

### Objective

Use inventory patterns to target selected hosts.

### Task 1: Test All Web Servers

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.ping
```

### Task 2: Test One Application Server

```bash
ansible app01 -i inventory/hosts.ini -m ansible.builtin.ping
```

### Task 3: Test All Production Servers

```bash
ansible production -i inventory/hosts.ini -m ansible.builtin.ping
```

### Task 4: Exclude Database Servers

```bash
ansible 'production:!databases' -i inventory/hosts.ini -m ansible.builtin.ping
```

### Task 5: Preview Before Execution

```bash
ansible 'production:!databases' -i inventory/hosts.ini --list-hosts
```

### Expected Result

You should be able to select the intended hosts without modifying the inventory each time.

---

## Lab 4: Collect Uptime, Memory, Disk, and OS Information

### Objective

Collect basic operational information from multiple managed nodes.

### Task 1: Uptime

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

### Task 2: Memory

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "free -h"
```

### Task 3: Disk Utilization

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

### Task 4: Operating System

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "cat /etc/os-release"
```

### Task 5: CPU Count

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "nproc"
```

### Expected Result

You should receive output from each reachable host.

Document any unreachable hosts separately from command failures.

---

## Lab 5: Install Packages Across Multiple Servers

### Objective

Install a package on the web server group.

For this example, assume the managed nodes are Ubuntu systems.

### Step 1: Update Package Metadata

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.apt -a "update_cache=yes"
```

### Step 2: Install Nginx

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.apt -a "name=nginx state=present"
```

### Step 3: Verify the Package

```bash
ansible webservers -i inventory/hosts.ini -m ansible.builtin.command -a "nginx -v"
```

Nginx may write its version to standard error rather than standard output.

### Step 4: Verify the Service

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.service -a "name=nginx state=started enabled=true"
```

### Expected Result

Nginx should be installed, running, and enabled at boot on the selected hosts, assuming the package and service configuration are supported.

For RHEL-family systems, use the appropriate package-management module or `ansible.builtin.package`.

---

## Lab 6: Manage Users and Services

### Objective

Create a user, create a group, and manage a service.

### Step 1: Create a Group

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.group -a "name=developers state=present"
```

### Step 2: Create a User

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.user -a "name=devops group=developers state=present"
```

### Step 3: Verify the User

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.command -a "id devops"
```

### Step 4: Start Nginx

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.service -a "name=nginx state=started"
```

### Step 5: Verify the Service

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.command -a "systemctl is-active nginx"
```

### Important Note

Creating a user does not automatically configure its password or SSH access.

In production, user provisioning must account for account security, authentication, authorized access, and lifecycle management.

---

## Lab 7: Troubleshoot Inventory and Connectivity Problems

### Objective

Learn to diagnose common Ansible inventory and connection failures.

### Scenario 1: Incorrect Inventory Path

Run:

```bash
ansible-inventory -i inventory/missing.ini --list
```

Investigate the error.

Then provide the correct inventory path.

### Scenario 2: Incorrect IP Address

Change a lab host to an invalid address.

Test:

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping -vvv
```

Observe the connection failure.

Restore the correct address after testing.

### Scenario 3: Incorrect SSH Username

Specify an incorrect username:

```bash
ansible web01 -i inventory/hosts.ini -u invaliduser -m ansible.builtin.ping
```

Observe the authentication failure.

Then restore the correct username.

### Scenario 4: Validate the Inventory Hierarchy

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

Verify the group names and membership.

### Scenario 5: Test SSH Independently

```bash
ssh automation@192.168.1.101
```

If SSH fails independently, troubleshoot the underlying connection before changing Ansible modules.

### Expected Result

You should be able to distinguish:

- Inventory parsing errors.
- Incorrect host selection.
- DNS or IP connectivity problems.
- SSH authentication failures.
- Remote command failures.
- Privilege escalation failures.

---

# 21. Troubleshooting

## Problem 1: Inventory Parsing Error

### Possible Causes

- Incorrect INI section syntax.
- YAML indentation errors.
- Invalid variable definitions.
- Unsupported inventory plugin configuration.
- Incorrect file extension or source configuration.

### Troubleshooting

Inspect the inventory:

```bash
ansible-inventory -i inventory/hosts.ini --list
```

Display the hierarchy:

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

For YAML inventories, validate the indentation and structure.

---

## Problem 2: Host Is Unreachable

### Possible Causes

- Wrong IP address.
- Incorrect SSH username.
- Invalid SSH key.
- SSH service is unavailable.
- Firewall or routing issue.
- Incorrect SSH port.

### Troubleshooting

Test SSH:

```bash
ssh automation@192.168.1.101
```

Run Ansible with verbose output:

```bash
ansible web01 -i inventory/hosts.ini -m ansible.builtin.ping -vvv
```

Check the connection settings and network path.

---

## Problem 3: Permission Denied

### Possible Causes

- Public key is missing.
- Wrong private key.
- Incorrect remote username.
- Incorrect file permissions.
- Remote account restrictions.

### Troubleshooting

Inspect the SSH connection:

```bash
ssh -v automation@192.168.1.101
```

Verify the key and remote account configuration.

---

## Problem 4: Sudo Failure

### Possible Causes

- Remote user lacks sudo privileges.
- A password is required.
- The sudoers policy restricts the requested operation.

### Troubleshooting

Check the remote account:

```bash
ssh automation@192.168.1.101
sudo -l
```

If the task requires a become password, use `-K`.

---

## Problem 5: Package Installation Failure

### Possible Causes

- Wrong package name.
- Unsupported package manager.
- Repository unavailable.
- Insufficient privileges.
- Network or DNS failure.
- Package metadata is outdated.

### Troubleshooting

Confirm the operating system:

```bash
ansible all -i inventory/hosts.ini -m ansible.builtin.command -a "cat /etc/os-release"
```

Then use the appropriate package-management module and investigate the underlying package manager error.

---

## Problem 6: Unexpected Host Selection

### Possible Causes

- Incorrect inventory.
- Incorrect group name.
- Misunderstood inventory pattern.
- Unexpected group membership.
- Incorrect `--limit` value.

### Troubleshooting

Preview the target set:

```bash
ansible 'production:!databases' -i inventory/hosts.ini --list-hosts
```

Inspect the hierarchy:

```bash
ansible-inventory -i inventory/hosts.ini --graph
```

Do this before running any operation that modifies production systems.

---

# 22. Security Best Practices

Follow these practices when working with inventories and ad hoc commands.

1. Do not store passwords or private keys in plaintext inventory files.
2. Use SSH key-based authentication where appropriate.
3. Keep SSH host-key verification enabled.
4. Use a dedicated automation account.
5. Apply least-privilege permissions.
6. Validate host selection before making changes.
7. Separate development, staging, and production inventories.
8. Use version control for inventory files, but exclude sensitive information.
9. Store secrets using Ansible Vault or an appropriate secrets manager.
10. Avoid running destructive commands against `all`.
11. Use verbose output carefully because it can expose sensitive information.
12. Test commands against a non-production host before broad execution.
13. Review package, service, and user-management operations before execution.
14. Use controlled concurrency for production maintenance.
15. Audit changes to inventory files and automation code.

An inventory is not a security boundary by itself. Access controls and execution safeguards must be enforced separately.

---

# 23. Real-World Scenarios

## Scenario 1: Check Disk Utilization Across 50 Servers

Objective: Collect filesystem utilization from all Linux application servers.

```bash
ansible appservers -i inventory/hosts.ini -m ansible.builtin.command -a "df -h"
```

Review the output and identify filesystems that require further investigation.

For automated threshold-based alerting, build a dedicated health-check playbook or monitoring workflow rather than relying on manual output inspection.

## Scenario 2: Restart Nginx on Web Servers

```bash
ansible webservers -i inventory/hosts.ini -b -m ansible.builtin.service -a "name=nginx state=restarted"
```

This restarts Nginx on every selected host.

For production systems, consider rolling restarts, load balancer health checks, and application availability before executing the command.

## Scenario 3: Check Application Server Uptime

```bash
ansible appservers -i inventory/hosts.ini -m ansible.builtin.command -a "uptime"
```

Use the output to identify hosts with unexpected uptime or high load averages.

High load average alone does not prove a performance problem; investigate CPU count, workload, and other system metrics.

## Scenario 4: Install a Security Update

The exact update procedure depends on the Linux distribution and organizational patch-management policy.

For an Ubuntu lab, updating package metadata is a separate step from applying package upgrades.

Do not perform broad package upgrades across production systems without testing, change approval, and an appropriate rollback or recovery plan.

## Scenario 5: AWS EC2 Fleet Management

A production inventory may contain instances grouped by:

- Environment.
- Application role.
- Region.
- Business service.

Static inventory can work for stable fleets, while dynamic inventory can discover instances and group them using cloud metadata.

Always ensure that the AWS credentials and IAM permissions used for discovery are appropriately restricted.

---

# 24. Interview Questions and Answers

## Q1. What is an Ansible inventory?

An inventory defines the hosts and groups that Ansible can target.

## Q2. What is a static inventory?

A static inventory is a manually maintained list of hosts, groups, and associated configuration.

## Q3. What are the supported static inventory formats covered in this module?

INI and YAML.

## Q4. What is the difference between a host and a group?

A host represents an individual managed machine. A group contains one or more hosts and can contain child groups.

## Q5. What is a child group?

A child group is nested under a parent group, allowing hosts to be organized hierarchically.

## Q6. What is an inventory alias?

An inventory alias is the name Ansible uses to identify a host independently of its actual connection address.

## Q7. What is the purpose of `ansible_host`?

It specifies the address Ansible should use to connect to the inventory host.

## Q8. What is the difference between host variables and group variables?

Host variables apply to individual hosts. Group variables apply to members of a group, subject to Ansible's variable-precedence rules.

## Q9. How do you display the inventory hierarchy?

```bash
ansible-inventory -i inventory.ini --graph
```

## Q10. How do you display the parsed inventory?

```bash
ansible-inventory -i inventory.ini --list
```

## Q11. What is an ad hoc command?

An ad hoc command performs a one-time operation on selected managed hosts without requiring a playbook file.

## Q12. What does `-m` mean?

It selects the module to execute.

## Q13. What does `-a` mean?

It passes arguments to the selected module.

## Q14. What is the difference between `command` and `shell`?

`command` executes a command without shell processing. `shell` runs the command through a shell and supports shell features such as pipes and redirection.

## Q15. What does `-b` do?

It enables privilege escalation, commonly through `sudo` on Linux.

## Q16. What is dynamic inventory?

Dynamic inventory obtains host information from an external source, such as a cloud provider or inventory plugin.

## Q17. What are forks?

Forks control the maximum number of parallel worker processes used for applicable Ansible operations.

## Q18. What does `rc=0` generally mean?

For Unix-like commands, a return code of zero generally indicates success.

## Q19. What does `UNREACHABLE` mean?

Ansible could not establish the required connection or otherwise reach the host for the operation.

## Q20. How would you safely execute a command against production servers?

Verify the inventory, preview the target hosts, test the operation in a lower environment, use appropriate permissions, and follow the organization's change-management procedures.

## Q21. Can a host belong to multiple inventory groups?

Yes. A host can belong to multiple groups, such as `webservers` and `production`.

## Q22. What is the difference between static and dynamic inventory?

Static inventory is explicitly maintained. Dynamic inventory discovers hosts from an external source using a supported plugin or script.

## Q23. Why is the Ansible ping module different from the Linux ping command?

The Ansible ping module tests Ansible's ability to execute on a managed node. The Linux `ping` command tests network reachability using ICMP echo requests.

## Q24. Why might a command module report `changed` even when the server configuration did not change?

For arbitrary commands, Ansible generally cannot determine whether the command changed system state. It may report `changed` based on the module's default behavior.

## Q25. How would you manage 500 AWS EC2 instances?

Use a suitable dynamic inventory source, organize hosts by application and environment, use appropriate execution limits, and validate changes through controlled automation workflows.

---

# 25. Knowledge Assessment

Try answering these questions before reading the answers in the documentation.

### Beginner

1. What is an inventory?
2. What is the difference between INI and YAML inventory?
3. What is a host group?
4. What is an inventory alias?
5. What is an ad hoc command?

### Intermediate

6. How do you define group variables?
7. How do you create a parent group?
8. What is the purpose of `ansible_host`?
9. What is the difference between `command` and `shell`?
10. How does privilege escalation work?

### Advanced

11. Why is dynamic inventory useful for AWS EC2?
12. What are the risks of executing commands against `all`?
13. How does `--limit` affect playbook execution?
14. How do forks influence parallel execution?
15. How do you troubleshoot an unreachable host?

### Practical Exercises

16. Create an inventory with five Linux servers.
17. Create groups for web, application, and database servers.
18. Target only the application servers.
19. Exclude database servers from a command.
20. Collect disk and memory information from all hosts.
21. Install Nginx on web servers.
22. Create a user on all development servers.
23. Inspect the inventory hierarchy.
24. Introduce an incorrect IP address and troubleshoot the failure.
25. Explain how you would organize a 100-server production inventory.

---

# 26. Module Completion Checklist

Before moving to Module 3, make sure you can:

- [ ] Explain the purpose of an inventory.
- [ ] Create a static INI inventory.
- [ ] Create a YAML inventory.
- [ ] Define hosts and groups.
- [ ] Build parent and child groups.
- [ ] Define host variables.
- [ ] Define group variables.
- [ ] Use inventory aliases.
- [ ] Separate development, staging, and production inventories.
- [ ] Use inventory patterns.
- [ ] Preview selected hosts.
- [ ] Explain dynamic inventory.
- [ ] Execute ad hoc commands.
- [ ] Use the ping, command, shell, file, package, service, user, and group modules.
- [ ] Collect uptime, memory, disk, and operating system information.
- [ ] Install packages on selected servers.
- [ ] Use privilege escalation.
- [ ] Understand forks and parallel execution.
- [ ] Interpret command output and return codes.
- [ ] Troubleshoot inventory parsing errors.
- [ ] Troubleshoot unreachable hosts.

## Module Completion Criteria

You are ready for Module 3 when you can independently create an inventory, organize hosts into groups, select the correct targets, execute administrative commands, and diagnose common connection failures.

Do not proceed simply because you understand the examples. Build the five-host lab and execute the commands yourself.

---

# 27. References

Use the official documentation as your primary reference.

- [Ansible Official Documentation](https://docs.ansible.com/ansible/latest/index.html)
- [Getting Started with Ansible](https://docs.ansible.com/ansible/latest/getting_started/index.html)
- [Building an Inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
- [Working with Inventory Hosts](https://docs.ansible.com/ansible/latest/inventory_guide/intro_patterns.html)
- [Ansible Ad Hoc Commands](https://docs.ansible.com/ansible/latest/command_guide/intro_adhoc.html)
- [Using Modules](https://docs.ansible.com/ansible/latest/module_plugin_guide/index.html)
- [Ansible Configuration Settings](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
- [AWS EC2 Inventory Plugin](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html)

---

## Final Message

Inventories tell Ansible which systems to target. Ad hoc commands let you perform quick administrative operations against those systems.

These capabilities form the foundation for larger automation workflows.

**Your objective is to manage multiple servers from one control node without losing track of which hosts you are targeting, what operation you are performing, or what the result means.**