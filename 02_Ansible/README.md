# Ansible Zero to Hero: A Complete Guide for Cloud & DevOps Engineers

Learn Ansible from absolute fundamentals to advanced infrastructure automation with practical examples, hands-on labs, real-world scenarios, and production-oriented projects.

This repository is designed for Linux Administrators, Cloud Engineers, DevOps Engineers, Site Reliability Engineers (SREs), and Platform Engineers.

## 🎯 Goal

By completing this roadmap, you will learn to:

- Automate Linux administration across multiple servers.
- Manage infrastructure configuration consistently.
- Write reusable, maintainable Ansible playbooks.
- Automate software installation and application deployment.
- Manage users, permissions, packages, services, and system configurations.
- Integrate Ansible with AWS infrastructure.
- Build reusable roles and collections.
- Secure sensitive information using Ansible Vault.
- Integrate Ansible into CI/CD pipelines.
- Troubleshoot automation failures.
- Implement production-oriented automation projects.

## Prerequisites

- Linux fundamentals and system administration.
- SSH, networking, users, groups, and permissions.
- Git and GitHub.
- Basic YAML syntax.
- Basic AWS knowledge.
- Familiarity with Bash scripting is helpful.

## Module 1: Ansible Fundamentals and Environment Setup

### Topics

- What is configuration management?
- What is Ansible, and why is it used?
- Ansible architecture.
- Control nodes and managed nodes.
- Agentless architecture and SSH communication.
- Push-based automation.
- Idempotency and declarative configuration.
- Ansible versus Bash, Terraform, Puppet, and Chef.
- Ansible installation and version verification.
- Python and SSH prerequisites.
- SSH key-based authentication.
- Sudo and privilege escalation fundamentals.
- Ansible configuration files and configuration precedence.
- Understanding `ansible.cfg`.

### Hands-on Labs

1. Install Ansible on a Linux control node.
2. Create two Linux managed nodes.
3. Configure SSH authentication.
4. Verify connectivity using the Ansible ping module.
5. Inspect Ansible configuration.
6. Execute your first remote command.
7. Troubleshoot SSH and authentication failures.

### Outcome

Build a working Ansible environment and understand how automation operates across multiple servers.

---

## Module 2: Inventory Management and Ad Hoc Commands

### Topics

- Static inventories.
- INI and YAML inventory formats.
- Hosts, groups, and child groups.
- Host variables and group variables.
- Inventory aliases.
- Development, staging, and production inventories.
- Inventory patterns and host selection.
- Introduction to dynamic inventories.
- Ad hoc command syntax.
- Common modules used with ad hoc commands.
- Parallel execution and forks.
- Remote command execution.
- Privilege escalation.
- Return codes and command output.

### Important Commands

```bash
ansible-inventory -i inventory.ini --list

ansible-inventory -i inventory.ini --graph

ansible all -i inventory.ini -m ansible.builtin.ping

ansible webservers -i inventory.ini -m ansible.builtin.command -a "uptime"

ansible all -i inventory.ini -m ansible.builtin.command -a "df -h"
```

### Hands-on Labs

1. Create an inventory containing five Linux servers.
2. Group servers by application role.
3. Execute commands against specific groups.
4. Collect uptime, memory, disk, and operating system information.
5. Install packages across multiple servers.
6. Manage users and services using ad hoc commands.
7. Troubleshoot inventory parsing and unreachable hosts.

### Outcome

Control and inspect multiple servers efficiently from a single control node.

---

## Module 3: YAML, Playbooks, Modules, Variables, and Facts

### Topics

**YAML fundamentals**
- Key-value pairs, lists, and dictionaries.
- Indentation and nesting.
- Strings, numbers, and Boolean values.
- YAML syntax validation.

**Playbooks**
- Plays and tasks.
- Hosts and task execution order.
- Fact gathering.
- Multiple plays.
- Tags and selective execution.
- Privilege escalation using `become`.
- Syntax checking, check mode, and diff mode.

**Modules**
- `command` and `shell`.
- `copy`, `file`, and `template`.
- `package`, `apt`, and `dnf`.
- `service` and `systemd_service`.
- `user` and `group`.
- `stat`, `fetch`, and `debug`.
- `lineinfile` and `blockinfile`.
- `assert` and `fail`.

**Variables and facts**
- Play, host, and group variables.
- Variables from external files.
- Registered variables.
- Built-in system facts.
- Custom facts.
- Variable precedence.
- Jinja2 expressions and filters.
- Conditional variable usage.

### Hands-on Labs

1. Write your first multi-task playbook.
2. Install and configure Nginx.
3. Create users and groups.
4. Manage files, directories, and permissions.
5. Register command output and use it in later tasks.
6. Collect system facts and generate server reports.
7. Create reusable variables for different environments.
8. Validate playbooks before execution.

### Outcome

Write structured playbooks that automate repeatable Linux administration tasks.

---

## Module 4: Conditions, Loops, Templates, Handlers, and Error Handling

### Topics

- Conditional execution using `when`.
- Loops using `loop`.
- Looping over dictionaries and lists.
- Registering task results.
- Jinja2 templating.
- Template variables and filters.
- Generating dynamic configuration files.
- Handlers and notifications.
- Task execution order.
- `changed_when` and `failed_when`.
- `ignore_errors` and `block`, `rescue`, and `always`.
- Assertions and precondition validation.
- Tags and task selection.
- Check mode and safe execution.
- Retry logic using `until`, `retries`, and `delay`.
- Delegation using `delegate_to`.
- Local and remote execution contexts.
- Asynchronous tasks and polling.

### Hands-on Labs

1. Install different packages on Ubuntu and RHEL-family servers.
2. Create multiple users using loops.
3. Generate Nginx configuration files using Jinja2 templates.
4. Restart services only when configuration changes.
5. Implement error recovery with `block`, `rescue`, and `always`.
6. Validate application ports and required directories.
7. Retry tasks when a service is temporarily unavailable.
8. Use tags to execute selected tasks.

### Outcome

Develop flexible automation that adapts to different systems, handles failures, and avoids unnecessary changes.

---

## Module 5: Reusable Roles, Collections, and Project Structure

### Topics

- Why reusable automation matters.
- Ansible project directory structure.
- Role directory conventions.
- Tasks, handlers, defaults, vars, files, templates, and metadata.
- Role variables and defaults.
- Role dependencies.
- Including and importing tasks.
- Including and importing roles.
- Ansible Galaxy.
- Installing external roles and collections.
- Fully qualified collection names.
- `requirements.yml`.
- Creating reusable internal automation components.
- Code reuse and maintainability.
- Role documentation and version control.

### Example Project Structure

```text
ansible-zero-to-hero/
├── ansible.cfg
├── inventory/
│   ├── dev/
│   │   ├── hosts.yml
│   │   └── group_vars/
│   └── prod/
│       ├── hosts.yml
│       └── group_vars/
├── playbooks/
│   ├── site.yml
│   ├── webservers.yml
│   └── users.yml
├── roles/
│   ├── common/
│   ├── nginx/
│   ├── users/
│   └── monitoring/
├── templates/
├── files/
├── requirements.yml
└── README.md
```

### Hands-on Labs

1. Create a reusable Nginx role.
2. Create a common Linux configuration role.
3. Separate default variables from role variables.
4. Reuse roles across multiple environments.
5. Install and use an external Ansible collection.
6. Create a complete playbook that combines multiple roles.
7. Document and version-control the project.

### Outcome

Build maintainable automation projects that can be reused across teams and environments.

---

## Module 6: Advanced Linux Administration and Production Automation

### Topics

- Automated Linux server provisioning and configuration.
- Package repository configuration.
- User and group lifecycle management.
- SSH configuration and access controls.
- File ownership, permissions, and ACLs.
- Sudoers configuration.
- Systemd service management.
- Cron jobs and scheduled tasks.
- Log rotation and log management.
- Firewall configuration.
- SELinux fundamentals.
- Linux security hardening.
- Kernel and system parameter management.
- Disk and filesystem management.
- Mount points and persistent mounts.
- Backup and restore automation.
- Configuration drift detection.
- Service health checks.
- Rolling updates and controlled restarts.
- Reboot handling.
- Safe execution and recovery procedures.

### Hands-on Labs

1. Standardize configurations across ten Linux servers.
2. Automate user provisioning and removal.
3. Configure SSH access and sudo privileges.
4. Deploy and manage systemd services.
5. Configure scheduled jobs.
6. Automate firewall rules.
7. Implement a baseline Linux hardening playbook.
8. Deploy application updates using rolling batches.
9. Detect and remediate configuration drift.
10. Build an automated server health report.

### Outcome

Automate real Linux administration tasks with an emphasis on repeatability, security, and operational reliability.

**Important:** Firewall changes, SSH restrictions, and security hardening should be tested on disposable systems first. Incorrect automation can lock you out of a server.

---

## Module 7: Ansible Vault, Security, and Secrets Management

### Topics

- Security principles for automation.
- Managing passwords, tokens, and private keys.
- Ansible Vault fundamentals.
- Encrypting files and variables.
- Encrypting individual strings.
- Decrypting and editing encrypted files.
- Vault passwords and password files.
- Vault IDs.
- Managing secrets across environments.
- `no_log` and sensitive task output.
- SSH key management.
- Least-privilege access.
- Sudo privilege management.
- Secure repository practices.
- Protecting secrets in CI/CD logs.
- Integrating with external secrets managers.
- Credential rotation strategies.

### Important Commands

```bash
ansible-vault create secrets.yml

ansible-vault encrypt secrets.yml

ansible-vault edit secrets.yml

ansible-vault view secrets.yml

ansible-vault decrypt secrets.yml

ansible-playbook site.yml --ask-vault-pass
```

### Hands-on Labs

1. Encrypt database credentials.
2. Store environment-specific secrets securely.
3. Run playbooks that consume encrypted variables.
4. Protect sensitive task output using `no_log`.
5. Separate development and production secrets.
6. Configure a secure workflow for encrypted files in Git.
7. Integrate Ansible with an external secrets manager.

### Outcome

Manage sensitive configuration data without exposing credentials in plaintext.

**Security rule:** Never commit plaintext passwords, private keys, API tokens, or unencrypted production secrets to GitHub.

---

## Module 8: AWS Cloud Automation and Dynamic Inventory

### Topics

- Ansible and AWS integration.
- AWS authentication and IAM roles.
- AWS CLI and credential configuration.
- Ansible AWS collections.
- Installing required collections and dependencies.
- EC2 instance discovery using dynamic inventory.
- Inventory grouping using tags.
- Automating EC2 operating system configuration.
- Managing packages and services on EC2 instances.
- Environment-specific configuration.
- Automating application deployment on EC2.
- AWS Systems Manager integration concepts.
- Secrets management with AWS services.
- Configuration management after Terraform provisioning.
- Infrastructure provisioning versus configuration management.
- Idempotency and safe execution in cloud environments.

### Example Workflow

```text
GitHub Repository
       |
       v
Terraform
       |
       v
AWS Infrastructure
       |
       v
EC2 Instances
       |
       v
Ansible Dynamic Inventory
       |
       v
Linux Configuration
       |
       v
Application Deployment
       |
       v
Validation and Health Checks
```

### Hands-on Labs

1. Configure AWS authentication securely.
2. Install the required AWS Ansible collection.
3. Discover EC2 instances using dynamic inventory.
4. Group instances using AWS tags.
5. Configure Nginx on EC2 instances.
6. Deploy an application to multiple EC2 servers.
7. Configure an application service and health checks.
8. Integrate Terraform provisioning with Ansible configuration.
9. Automate development-environment configuration.
10. Validate AWS permissions and troubleshoot authentication failures.

### Outcome

Combine infrastructure provisioning and configuration management to automate AWS environments.

**Important:** Terraform is generally suited to provisioning infrastructure resources, while Ansible is well suited to configuring operating systems and deploying applications. AWS automation modules can also manage cloud resources when appropriate.

---

## Module 9: CI/CD Integration, Testing, and Ansible Troubleshooting

### Topics

**CI/CD integration**
- Ansible with Jenkins.
- Ansible with GitHub Actions.
- Ansible with GitLab CI/CD.
- Git-based automation workflows.
- Automated deployment pipelines.
- Environment-specific deployment.
- Approval gates for production.
- Secure credential injection.
- Artifact deployment.
- Rollback strategies.

**Testing and quality**
- YAML validation.
- Ansible syntax checks.
- Ansible Lint.
- Molecule testing concepts.
- Role testing.
- Idempotency testing.
- Check mode and diff mode.
- Automated pre-deployment validation.

**Troubleshooting**
- SSH connectivity failures.
- Unreachable hosts.
- Permission and sudo failures.
- Undefined variables.
- YAML syntax errors.
- Module failures.
- Inventory parsing problems.
- Collection and dependency issues.
- Failed handlers.
- Task execution debugging.
- Verbose output.
- Logging and error analysis.
- Performance tuning and parallel execution.
- Troubleshooting failed production deployments.

### Important Commands

```bash
ansible-playbook site.yml --syntax-check

ansible-playbook site.yml --check --diff

ansible-playbook site.yml -vvv

ansible-inventory -i inventory/hosts.yml --graph

ansible-lint playbooks/
```

### Hands-on Labs

1. Build a Jenkins pipeline that runs Ansible playbooks.
2. Create a GitHub Actions workflow for Ansible validation.
3. Validate YAML and playbook syntax before deployment.
4. Run Ansible Lint in CI.
5. Automate application deployment to staging.
6. Implement approval-based production deployment.
7. Test roles and verify idempotency.
8. Troubleshoot intentionally broken playbooks.
9. Implement deployment validation and rollback procedures.

### Outcome

Integrate Ansible into automated software delivery pipelines and develop the skills to diagnose automation failures.

---

## Module 10: Advanced Ansible, Production Architecture, and Real-World Projects

### Topics

**Advanced Ansible**
- Dynamic inventory architecture.
- Advanced variable precedence.
- Custom facts and fact caching.
- Delegation and execution strategies.
- Serial execution and rolling deployments.
- Throttling and parallelism.
- Async tasks and polling.
- Blocks and failure recovery.
- Check mode limitations.
- Ansible performance optimization.
- Custom modules and plugins: introduction.
- Ansible Runner and Automation Controller concepts.
- AWX and enterprise automation architecture.
- Execution environments and dependency management.
- Ansible Automation Platform concepts.
- Automation governance and auditability.
- Production change management.

**Observability and operational reliability**
- Automated health checks.
- Configuration drift reporting.
- Deployment verification.
- Failure notifications.
- Centralized logging concepts.
- Automated remediation with safeguards.

**Real-world projects**

### Project 1: Automated Linux Server Setup

Build automation that configures new Linux servers with packages, users, SSH settings, directories, and baseline security controls.

### Project 2: Multi-Server Nginx Deployment

Deploy Nginx to multiple servers, generate virtual host configurations, validate the configuration, and restart services only when required.

### Project 3: Java Application Deployment

Automate Java runtime installation, application artifact deployment, systemd service configuration, health checks, and controlled rollback.

### Project 4: AWS EC2 Configuration Management

Use Terraform to provision EC2 instances and Ansible to configure them, install dependencies, and deploy an application.

### Project 5: CI/CD-Based Application Deployment

Build a Jenkins or GitHub Actions pipeline that validates Ansible code and deploys an application to a staging environment.

### Project 6: Linux Security Hardening

Automate user access controls, SSH configuration, firewall settings, package updates, and security baseline validation.

### Project 7: Configuration Drift Detection

Periodically validate server configurations and report deviations from the intended configuration.

### Project 8: Production-Style Infrastructure Automation

Combine inventories, roles, Vault, dynamic inventory, CI/CD, deployment verification, and failure recovery into one maintainable project.

### Outcome

Build a portfolio of automation projects that demonstrate practical Ansible skills for Cloud, DevOps, SRE, and Platform Engineering roles.

---

# Recommended Learning Strategy

Follow the modules in order, but do not stop at reading the documentation.

For every module:

1. Learn the concepts.
2. Write the automation yourself.
3. Test it on at least two Linux servers.
4. Introduce a failure deliberately.
5. Troubleshoot the failure.
6. Validate idempotency wherever applicable.
7. Document the solution in GitHub.
8. Explain the implementation and trade-offs in your own words.

## Final Goal

By completing all ten modules and the hands-on projects, you should be able to design, implement, troubleshoot, and maintain Ansible automation for common Linux administration, AWS configuration management, and application deployment workflows.

Your GitHub repository should demonstrate working automation, not just theoretical knowledge.