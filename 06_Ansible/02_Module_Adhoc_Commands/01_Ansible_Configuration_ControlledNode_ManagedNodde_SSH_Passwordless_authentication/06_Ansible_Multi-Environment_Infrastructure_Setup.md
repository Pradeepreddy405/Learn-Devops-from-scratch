# Ansible Multi-Environment Infrastructure Setup (AWS EC2)

## 1. Project Overview

This project demonstrates how to configure and manage multiple Linux servers across different environments using Ansible.

We will build an AWS EC2 infrastructure consisting of:

- 1 Ansible Controller Node
- 2 Development Managed Nodes
- 2 Testing Managed Nodes
- 2 Production Managed Nodes

**Total Infrastructure: 7 EC2 Instances (1 Controller + 6 Managed Nodes)**

The objective is to understand how Ansible manages multiple environments using inventory groups, SSH connectivity and ad-hoc commands, initially without using an `ansible.cfg` configuration file.

---

## 2. Infrastructure Architecture

```text
                       AWS EC2 Infrastructure

                      Ansible Controller
                         (Management)
                              |
                 SSH Connections (Port 22)
                              |
          +-------------------+-------------------+
          |                   |                   |
     Development             Testing           Production
          |                   |                   |
     +----+----+         +----+----+         +----+----+
     |         |         |         |         |         |
  ANode1    ANode4     ANode2    ANode5     ANode3    ANode6
  Existing   New       Existing   New       Existing   New
```

### Server Details

| Environment | Hostname | Private IP | Status |
|---|---|---|---|
| Development | ANode1 | 172.31.27.54 | Existing |
| Development | ANode4 | Pending | New |
| Testing | ANode2 | 172.31.24.28 | Existing |
| Testing | ANode5 | Pending | New |
| Production | ANode3 | 172.31.29.72 | Existing |
| Production | ANode6 | Pending | New |

*Update the pending IP addresses after launching the new EC2 instances.*

---

## 3. AWS EC2 Configuration

Launch three additional EC2 instances with the following configuration.

| Configuration | Value |
|---|---|
| Operating System | Amazon Linux 2023 |
| Instance Type | t2.micro or eligible instance type |
| Storage | 8 GiB |
| Key Pair | Existing Ansible SSH key |
| Security Group | Managed Nodes Security Group |
| Number of Instances | 3 |

### Instance Naming

```text
ANode4-Development
ANode5-Testing
ANode6-Production
```

### Security Group Configuration

Configure the managed-node security group:

| Type | Protocol | Port | Source |
|---|---|---|---|
| SSH | TCP | 22 | Ansible Controller Security Group |

Allow required outbound connectivity.

**Important:** Avoid exposing SSH to the entire internet (`0.0.0.0/0`). Use the controller's security group as the SSH source.

---

## 4. SSH Configuration on Ansible Controller

Ansible uses SSH to communicate with Linux managed nodes.

Edit the SSH configuration file:

```bash
vi ~/.ssh/config
```

Add the following configuration:

```sshconfig
Host ANode1
    HostName 172.31.27.54
    User ec