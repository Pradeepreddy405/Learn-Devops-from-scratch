# Ansible Configuration Management (`ansible.cfg`)
## From Pure Scratch to Successful Managed Node Connectivity

**Technology:** Ansible  
**Environment:** AWS EC2 – Amazon Linux 2023  
**Ansible Version:** 2.15.3  
**Control Node:** Ansible Control Node  
**Managed Nodes:** node1 and node2  
**Authentication:** SSH Key-Based Authentication

---

# 1. Introduction

When working with Ansible, we need to configure several parameters before communicating with managed nodes.

For example:

- Inventory file location
- Remote SSH username
- SSH private key location
- Host key checking
- Other Ansible execution settings

There are two approaches to configuring these parameters:

1. Without an `ansible.cfg` file – Specify the configuration details every time through command-line arguments.
2. With an `ansible.cfg` file – Define the common configuration settings once and allow Ansible to discover and reuse them.

**Why do we need ansible.cfg?**

Imagine executing 50 different Ansible commands. Repeatedly providing inventory paths, SSH usernames and private key paths becomes inconvenient.

The `ansible.cfg` file provides centralized configuration, reduces command repetition and improves maintainability.

# 2. Understand the Ansible Architecture

Before configuring Ansible, understand how the Control Node communicates with Managed Nodes.

## 2.1 Architecture diagram

```text
                  ANSIBLE ARCHITECTURE

             AWS EC2 Environment
   ___________________________________________

   |                                         |
   |          CONTROL NODE                   |
   |                                         |
   |       Ansible Core Installed            |
   |                                         |
   |       Inventory File                    |
   |       ansible.cfg                       |
   |       SSH Private Key                   |
   |                                         |
   |       ansible all -m ping               |
   |                  |                      |
   |__________________|______________________|
                      |
                      | SSH Port 22
                      |
             _________|_________
            |                   |
            |                   |
      Managed Node 1     Managed Node 2
       172.31.16.19       172.31.20.45

       SSH Authentication using authorized public keys
```

## 2.2 Components and their purposes

| Component | Purpose |
|---|---|
| Control Node | Executes Ansible commands |
| Managed Nodes | Receive and execute Ansible tasks |
| Inventory | Contains managed node information |
| SSH Private Key | Authenticates the Control Node |
| SSH Public Key | Must be authorized on the Managed Nodes |
| ansible.cfg | Stores default Ansible configuration |
| Ansible Module | Performs a particular operation |

**Important:** Ansible is agentless. We do not need to install Ansible on every managed node. Ansible communicates with Linux managed nodes over SSH.

# 3. Prerequisites – Before Starting

We need three EC2 instances:

- One Control Node
- Two Managed Nodes

### 3.1 Network connectivity

Configure the security groups:

**Control Node Security Group**

Outbound:
- By default, AWS Security Groups allow all outbound traffic.
- Therefore, no additional outbound SSH rule is required for this lab.

**Managed Nodes Security Group**

Inbound:
- SSH TCP 22.
- Source: Control Node Security Group.

Avoid opening SSH to the entire internet.

### 3.2 Verify SSH connectivity

From the Control Node:

```bash
telnet 172.31.16.19 22
```

Expected:

```text
Trying 172.31.16.19...
Connected to 172.31.16.19.
SSH-2.0-OpenSSH_9.9
```

This verifies TCP connectivity, not successful SSH authentication.

Exit Telnet using:

```text
Ctrl + ]
quit
```

### 3.3 Verify SSH private key

On the Control Node:

```bash
ls -lah ~/.ssh/
```

Example:

```text
ansible_lab
ansible_lab.pub
authorized_keys
known_hosts
```

Here:

- `ansible_lab` = Private key
- `ansible_lab.pub` = Public key

Set secure private key permissions:

```bash
chmod 400 ~/.ssh/ansible_lab
```

The private key must correspond to the public key authorized on the managed nodes.

# 4. Approach 1 – Ansible Without ansible.cfg

## 4.1 Introduction

In this approach, we do not create an `ansible.cfg` file.

Whenever we execute an Ansible command, we manually provide the required configuration through command-line arguments.

## 4.2 Step 1 – Create a project directory

On the Control Node:

```bash
mkdir ansible-raw-lab
```

Navigate into it:

```bash
cd ansible-raw-lab
```

Verify:

```bash
pwd
```

Expected:

```text
/home/ec2-user/ansible-raw-lab
```

## 4.3 Step 2 – Create the inventory directory

```bash
mkdir inventory
```

Create the inventory file:

```bash
vi inventory/hosts
```

Add:

```ini
[managed_nodes]

node1 ansible_host=172.31.16.19

node2 ansible_host=172.31.20.45
```

Save and exit.

### What is inventory?

Inventory is a file that tells Ansible which machines it needs to manage.

Explanation:

| Configuration | Meaning |
|---|---|
| `[managed_nodes]` | Group name |
| `node1` | Ansible inventory hostname |
| `ansible_host` | Actual IP address of the managed node |
| `172.31.16.19` | Private IP of node1 |
| `node2` | Second inventory hostname |
| `172.31.20.45` | Private IP of node2 |

## 4.4 Step 3 – Verify inventory

```bash
cat inventory/hosts
```

Expected:

```ini
[managed_nodes]
node1 ansible_host=172.31.16.19
node2 ansible_host=172.31.20.45
```

## 4.5 Step 4 – Verify Ansible installation

```bash
ansible --version
```

Example:

```text
ansible [core 2.15.3]
config file = None
```

**What does config file = None mean?**

It means Ansible has not discovered an Ansible configuration file.

This is expected because we have not created `ansible.cfg` or explicitly provided one through `ANSIBLE_CONFIG`.

## 4.6 Step 5 – Execute the Ansible ping command

Now execute:

```bash
ansible all \
-i /home/ec2-user/ansible-raw-lab/inventory/hosts \
-u ec2-user \
--private-key /home/ec2-user/.ssh/ansible_lab \
-m ping
```

### Understand every argument

| Argument | Meaning |
|---|---|
| `ansible` | Ansible ad-hoc command |
| `all` | Target all hosts in the inventory |
| `-i` | Specifies inventory file |
| Inventory path | Location of managed node information |
| `-u ec2-user` | SSH username on managed nodes |
| `--private-key` | SSH private key location |
| `-m ping` | Execute the Ansible ping module |

### Expected output

```text
node1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

node2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

### What does this output mean?

- `SUCCESS`: Ansible successfully communicated with the managed node.
- `changed: false`: No system configuration was changed.
- `ping: pong`: The Ansible ping module successfully executed.

**Important:** Ansible's ping module does not simply test ICMP connectivity. It verifies Ansible's ability to communicate with the managed node and execute the module.

## 4.7 Why is this approach repetitive?

Imagine you want to execute different Ansible modules:

```bash
ansible all -i /home/ec2-user/ansible-raw-lab/inventory/hosts -u ec2-user --private-key /home/ec2-user/.ssh/ansible_lab -m ping
```

```bash
ansible all -i /home/ec2-user/ansible-raw-lab/inventory/hosts -u ec2-user --private-key /home/ec2-user/.ssh/ansible_lab -m command -a "uptime"
```

```bash
ansible all -i /home/ec2-user/ansible-raw-lab/inventory/hosts -u ec2-user --private-key /home/ec2-user/.ssh/ansible_lab -m shell -a "df -h"
```

Notice that the following details are repeated:

1. Inventory location
2. SSH username
3. SSH private key location

Only the module and its arguments change.

This becomes difficult to maintain when managing multiple servers and executing many commands.

# 5. Approach 2 – Ansible With ansible.cfg

## 5.1 Introduction

Instead of specifying common configuration details repeatedly, we create an Ansible configuration file.

The configuration file stores default values that Ansible can automatically discover and reuse.

## 5.2 Step 1 – Understand the project structure

Our existing project:

```text
ansible-raw-lab/
│
└── inventory/
    └── hosts
```

After creating `ansible.cfg`:

```text
ansible-raw-lab/
│
├── ansible.cfg
│
└── inventory/
    └── hosts
```

## 5.3 Step 2 – Create ansible.cfg

Navigate to the project directory:

```bash
cd /home/ec2-user/ansible-raw-lab
```

Create the configuration file:

```bash
vi ansible.cfg
```

Add:

```ini
[defaults]

inventory = ./inventory/hosts

remote_user = ec2-user

private_key_file = /home/ec2-user/.ssh/ansible_lab

host_key_checking = False
```

Save and exit.

### Understand every configuration parameter

| Parameter | Explanation |
|---|---|
| `[defaults]` | Default Ansible configuration section |
| `inventory` | Default inventory file |
| `remote_user` | Default SSH username |
| `private_key_file` | Default SSH private key |
| `host_key_checking` | Controls SSH host key verification |

**Security note:** Disabling host key checking is convenient in disposable labs, but it is not recommended as a general production security practice. Production environments should verify and manage trusted SSH host keys.

## 5.4 Step 3 – Verify configuration file

```bash
cat ansible.cfg
```

Expected:

```ini
[defaults]
inventory = ./inventory/hosts
remote_user = ec2-user
private_key_file = /home/ec2-user/.ssh/ansible_lab
host_key_checking = False
```

## 5.5 Step 4 – Understand automatic configuration discovery

Ansible searches for its configuration file in this order:

1. Path specified by `ANSIBLE_CONFIG` environment variable.
2. `ansible.cfg` in the current working directory.
3. `~/.ansible.cfg` in the user's home directory.
4. `/etc/ansible/ansible.cfg`.

Ansible uses the first configuration file it finds.

**Important:** Ansible does not merge all these configuration files. It selects one configuration file.

## 5.6 Step 5 – Verify configuration detection

Execute:

```bash
ansible --version
```

Expected:

```text
ansible [core 2.15.3]

config file = /home/ec2-user/ansible-raw-lab/ansible.cfg
```

This confirms that Ansible has automatically detected the project-level configuration file.

## 5.7 Step 6 – Execute Ansible ping

Previously, we executed:

```bash
ansible all \
-i /home/ec2-user/ansible-raw-lab/inventory/hosts \
-u ec2-user \
--private-key /home/ec2-user/.ssh/ansible_lab \
-m ping
```

Now execute only:

```bash
ansible all -m ping
```

Expected:

```text
node1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}

node2 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

**What happened?**

Ansible automatically obtained:

- Inventory path from `ansible.cfg`.
- SSH username from `ansible.cfg`.
- SSH private key from `ansible.cfg`.

We no longer need to specify these common settings every time.

# 6. How Does Ansible Use ansible.cfg?

## 6.1 Configuration workflow diagram

```text
             Execute Ansible Command
                       |
                       |
                ansible all -m ping
                       |
                       |
             Ansible Configuration
                 Discovery
                       |
                       |
              Is ANSIBLE_CONFIG
                environment set?
                 /          \
               YES           NO
                |             |
          Use specified    Search current
          configuration    working directory
                |             |
                |        Is ansible.cfg
                |           present?
                |          /      \
                |        YES       NO
                |         |         |
                |     Load file   Search home
                |                 directory
                |                     |
                |                 Search system
                |                 configuration
                |                     |
                |_____________________|
                       |
                       |
              Load Configuration
                       |
                       |
                Read Inventory
                       |
                       |
                SSH Authentication
                       |
                       |
              Execute Ping Module
                       |
                 ______|______
                |             |
              SUCCESS       FAILURE
```

# 7. Environment Variables – Temporary Configuration

## 7.1 What is an environment variable?

An environment variable is a named value maintained by the operating system's process environment.

Applications can read these values to determine how they should behave.

For Ansible, one important environment variable is:

```bash
ANSIBLE_CONFIG
```

It tells Ansible which configuration file to use.

## 7.2 Configure ANSIBLE_CONFIG temporarily

Suppose we are currently working inside:

```text
/home/ec2-user
```

But our configuration file is located here:

```text
/home/ec2-user/ansible-raw-lab/ansible.cfg
```

We can explicitly specify its location.

Execute:

```bash
export ANSIBLE_CONFIG=/home/ec2-user/ansible-raw-lab/ansible.cfg
```

Verify:

```bash
echo $ANSIBLE_CONFIG
```

Expected:

```text
/home/ec2-user/ansible-raw-lab/ansible.cfg
```

Now execute:

```bash
ansible --version
```

Ansible should display:

```text
config file = /home/ec2-user/ansible-raw-lab/ansible.cfg
```

We can now execute:

```bash
ansible all -m ping
```

### What makes it temporary?

The `export` command sets the variable in the current shell environment.

It is inherited by child processes, including Ansible commands.

When that shell session ends, the variable normally disappears.

## 7.3 Remove a temporary environment variable

Execute:

```bash
unset ANSIBLE_CONFIG
```

Verify:

```bash
echo $ANSIBLE_CONFIG
```

Expected: Empty output.

Now navigate into the project:

```bash
cd /home/ec2-user/ansible-raw-lab
```

Execute:

```bash
ansible --version
```

Ansible should still detect:

```text
config file = /home/ec2-user/ansible-raw-lab/ansible.cfg
```

Why?

Because Ansible can discover the configuration file in the current working directory without requiring an environment variable.

# 8. Environment Variables – Permanent Configuration

## 8.1 Why do we need permanent environment variables?

Suppose we want Ansible to use a particular configuration file whenever we open a new interactive Bash session.

Instead of manually executing:

```bash
export ANSIBLE_CONFIG=/home/ec2-user/ansible-raw-lab/ansible.cfg
```

every time, we can add the command to a Bash startup configuration file.

For this example, we use:

```text
~/.bashrc
```

## 8.2 Step 1 – Open .bashrc

```bash
vi ~/.bashrc
```

Add at the bottom:

```bash
export ANSIBLE_CONFIG=/home/ec2-user/ansible-raw-lab/ansible.cfg
```

Save and exit.

## 8.3 Step 2 – Reload .bashrc

Execute:

```bash
source ~/.bashrc
```

What does this command do?

It executes the contents of `.bashrc` in the currently running shell.

No EC2 reboot is required.

No shell restart is required.

## 8.4 Step 3 – Verify the environment variable

```bash
echo $ANSIBLE_CONFIG
```

Expected:

```text
/home/ec2-user/ansible-raw-lab/ansible.cfg
```

Another way:

```bash
printenv ANSIBLE_CONFIG
```

## 8.5 Step 4 – Verify Ansible

```bash
ansible --version
```

Expected:

```text
config file = /home/ec2-user/ansible-raw-lab/ansible.cfg
```

The environment variable is now automatically set whenever a new interactive Bash shell loads `.bashrc`.

## 8.6 Important difference: source and unset

Consider this scenario:

Initially, `.bashrc` contains:

```bash
export DEMO=HELLO
```

Execute:

```bash
source ~/.bashrc
```

Verify:

```bash
echo $DEMO
```

Output:

```text
HELLO
```

Now remove the export statement from `.bashrc`.

Execute:

```bash
source ~/.bashrc
```

Will `DEMO` disappear?

No.

Why?

Because removing an export statement from `.bashrc` does not remove a variable that already exists in the current shell.

We must explicitly execute:

```bash
unset DEMO
```

Verify:

```bash
echo $DEMO
```

Expected: Empty output.

The same principle applies to `ANSIBLE_CONFIG`.

## 8.7 Temporary vs Permanent comparison

| Feature | Temporary | Persistent |
|---|---|---|
| Command | `export VAR=value` | Add export to `~/.bashrc` |
| Current shell | Yes | Yes, after loading |
| New shell | Not automatically | Yes, for shells loading `.bashrc` |
| Reboot required | No | No |
| Removal | `unset VAR` | Remove export and unset current variable |
| Purpose | Temporary testing | Repeated shell configuration |

**Important:** `.bashrc` applies to interactive Bash shells that load it. It does not automatically configure every Linux process, service or non-interactive shell.

# 9. Important Troubleshooting Scenarios

These scenarios are based on practical issues encountered during this lab.

## Scenario 1 – Configuration file not detected

Command:

```bash
ansible --version
```

Output:

```text
config file = None
```

Possible reasons:

- No `ansible.cfg` exists in the searched locations.
- You are in the wrong working directory.
- `ANSIBLE_CONFIG` points to an invalid path.

Troubleshooting:

```bash
pwd
```

```bash
ls -l ansible.cfg
```

```bash
echo $ANSIBLE_CONFIG
```

```bash
ansible --version
```

## Scenario 2 – Wrong ANSIBLE_CONFIG path

Suppose `.bashrc` contains:

```bash
export ANSIBLE_CONFIG=/home/ec2-user/ansible-lab/ansible.cfg
```

But the actual configuration file is:

```text
/home/ec2-user/ansible-raw-lab/ansible.cfg
```

Ansible checks the environment variable first.

If the specified file does not exist, it does not fall back to the project-level configuration file.

Solution:

```bash
unset ANSIBLE_CONFIG
```

Then:

```bash
cd /home/ec2-user/ansible-raw-lab
```

Verify:

```bash
ansible --version
```

## Scenario 3 – Private key not found

Error:

```text
no such identity: /home/ec2-user/.ssh/ansible_lab:
No such file or directory
```

Reason:

The private key path in `ansible.cfg` does not match the actual private key location.

Verify:

```bash
ls -lah ~/.ssh/
```

Update:

```ini
private_key_file = /home/ec2-user/.ssh/ansible_lab_Change
```

Use the actual verified private key path.

## Scenario 4 – Permission denied

Error:

```text
Permission denied (publickey)
```

Possible causes:

- Incorrect private key.
- Wrong SSH username.
- Public key is not authorized on the managed node.
- Incorrect private key permissions.

Check:

```bash
chmod 400 ~/.ssh/ansible_lab
```

Test direct SSH:

```bash
ssh -i ~/.ssh/ansible_lab ec2-user@172.31.16.19
```

## Scenario 5 – Inventory not detected

Check:

```bash
ansible-inventory --graph
```

Expected:

```text
@all:
  |--@managed_nodes:
  |  |--node1
  |  |--node2
```

Check configuration:

```bash
ansible-config dump --only-changed
```

## Scenario 6 – TCP connectivity failure

If SSH cannot reach the managed node, verify:

- Security group inbound rule.
- Control Node outbound rule.
- Correct private IP.
- Network ACLs and routing.
- SSH service status on the destination.

Remember that a successful Telnet connection to port 22 confirms TCP connectivity, not successful authentication.

# 10. Configuration Precedence – Important Concept

Ansible supports several ways of providing configuration values.

For a particular setting, the general precedence is:

1. Command-line options, where supported.
2. Environment variables.
3. Configuration file settings.
4. Ansible built-in defaults.

For configuration file discovery, however, the search order is:

1. `ANSIBLE_CONFIG`
2. Current working directory's `ansible.cfg`
3. `~/.ansible.cfg`
4. `/etc/ansible/ansible.cfg`

These are two different concepts:

- Configuration discovery determines which configuration file is loaded.
- Configuration precedence determines which value wins when multiple sources provide a setting.

Example:

Your `ansible.cfg`:

```ini
[defaults]
remote_user = ec2-user
```

Command:

```bash
ansible all -m ping -u root
```

The command-line username overrides the configuration file's username.

# 11. Complete Comparison – Without vs With ansible.cfg

| Parameter | Without ansible.cfg | With ansible.cfg |
|---|---|---|
| Inventory | Specify using `-i` | Configure once |
| SSH username | Specify using `-u` | Configure once |
| Private key | Specify using `--private-key` | Configure once |
| Host key checking | Configure separately if needed | Configure centrally |
| Command length | Longer | Shorter |
| Repetition | High | Low |
| Maintenance | More manual | Centralized |
| Team collaboration | More repeated instructions | Shared project defaults |
| Scalability | Less convenient | More maintainable |

## 11.1 Command comparison

**Without ansible.cfg:**

```bash
ansible all \
-i /home/ec2-user/ansible-raw-lab/inventory/hosts \
-u ec2-user \
--private-key /home/ec2-user/.ssh/ansible_lab \
-m ping
```

**With ansible.cfg:**

```bash
ansible all -m ping
```

The second command is shorter because the common settings are already configured.

# 12. Real-World DevOps Application

Imagine working in a DevOps team managing multiple AWS environments.

Your project might look like:

```text
ansible-project/
│
├── ansible.cfg
│
├── inventory/
│   ├── dev/
│   │   └── hosts
│   │
│   ├── staging/
│   │   └── hosts
│   │
│   └── production/
│       └── hosts
│
├── playbooks/
│   ├── install_nginx.yml
│   ├── deploy_application.yml
│   ├── system_health.yml
│   └── security_updates.yml
│
└── roles/
    ├── nginx/
    ├── docker/
    └── monitoring/
```

You can define common defaults in `ansible.cfg` and select different inventories when executing commands.

For example:

```bash
ansible all -i inventory/dev/hosts -m ping
```

```bash
ansible all -i inventory/staging/hosts -m ping
```

```bash
ansible all -i inventory/production/hosts -m ping
```

The command-line inventory overrides the default inventory configured in `ansible.cfg`.

In production, SSH keys, credentials, access permissions and host key verification must be managed securely.

# 13. Final Learning Summary – Sequential Order

Follow this sequence to understand the complete workflow.

### Phase 1 – Without ansible.cfg

1. Understand Control Node and Managed Nodes.
2. Configure AWS Security Groups.
3. Establish TCP connectivity on port 22.
4. Configure SSH key-based authentication.
5. Create an Ansible project directory.
6. Create an inventory directory.
7. Create the inventory file.
8. Verify the inventory.
9. Check Ansible installation.
10. Observe `config file = None`.
11. Execute the Ansible ping command with `-i`, `-u` and `--private-key`.
12. Verify `SUCCESS` and `pong`.
13. Understand why the command is repetitive.

### Phase 2 – With ansible.cfg

14. Understand why centralized configuration is needed.
15. Create `ansible.cfg`.
16. Configure the inventory path.
17. Configure the SSH username.
18. Configure the private key path.
19. Configure host key checking.
20. Understand automatic configuration discovery.
21. Verify using `ansible --version`.
22. Execute `ansible all -m ping`.
23. Verify both managed nodes.

### Phase 3 – Environment Variables

24. Understand environment variables.
25. Understand `ANSIBLE_CONFIG`.
26. Configure it temporarily using `export`.
27. Verify using `echo` and `printenv`.
28. Remove it using `unset`.
29. Understand `.bashrc`.
30. Configure it persistently through `.bashrc`.
31. Reload using `source ~/.bashrc`.
32. Understand why removing a line from `.bashrc` does not unset an existing variable.
33. Understand why no shell restart or EC2 reboot is required after sourcing.
34. Troubleshoot incorrect configuration paths.
35. Understand configuration discovery versus configuration precedence.

# 14. Final Conclusion – Why Do We Need ansible.cfg?

Without `ansible.cfg`, we must repeatedly provide common configuration information through command-line arguments.

With `ansible.cfg`, we define common settings once and allow Ansible to automatically discover and reuse them.

The key advantages are:

1. Reduced command repetition.
2. Centralized configuration management.
3. Improved maintainability.
4. Consistent execution.
5. Easier team collaboration.
6. Better organization of large Ansible projects.

**Final takeaway:**

`ansible.cfg` is not mandatory for Ansible to work. We can execute Ansible commands without it.

However, as our infrastructure grows from two EC2 instances to dozens or hundreds of servers, centralized configuration becomes increasingly valuable.

It is one of the foundational concepts for managing Ansible in real-world Cloud and DevOps environments.

---
