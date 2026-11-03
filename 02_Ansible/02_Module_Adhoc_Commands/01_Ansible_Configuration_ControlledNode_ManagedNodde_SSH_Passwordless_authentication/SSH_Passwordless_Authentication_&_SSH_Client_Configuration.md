# SSH Passwordless Authentication & SSH Client Configuration (Linux / DevOps)

## 1. Introduction

SSH (Secure Shell) is a network protocol used to securely connect to remote Linux servers over an encrypted connection.

In DevOps environments, administrators and automation tools such as Ansible frequently connect to multiple Linux servers.

Instead of entering passwords or specifying private key paths every time, we can configure **SSH Public Key Authentication** to establish secure, passwordless connections.

This hands-on guide covers:

- SSH fundamentals.
- Public key and private key authentication.
- Generating SSH key pairs.
- Configuring passwordless authentication.
- Understanding `authorized_keys`.
- Using SSH configuration files.
- Managing multiple Linux servers using SSH aliases.
- Troubleshooting SSH authentication.
- Integrating SSH configuration with Ansible.

---

## 2. Understanding SSH Authentication

SSH supports multiple authentication methods. One commonly used method in DevOps environments is public-key authentication.

Public-key authentication uses two cryptographic keys:

| Key | Purpose | Location |
|---|---|---|
| Private Key | Proves the client's identity | SSH Controller |
| Public Key | Allows the server to authenticate the client | Managed Node |

**Important:**
- The private key must remain secure on the controller.
- The public key can be shared with managed nodes.
- Never share or expose your private key.

### SSH authentication architecture

```text
             SSH Controller
             (Ansible Server)
                   |
                   |
          Ansible_key (Private)
                   |
                   |
             SSH Connection
                   |
          ---------------------
          |         |         |
          v         v         v
       Node 1    Node 2    Node 3
          |         |         |
          v         v         v
     authorized_keys on each node
          |         |         |
          ---------------------
                   |
           Public Key Matching
                   |
          Authentication Success
```

---

## 3. Lab Environment

For this hands-on exercise, we are using four Amazon Linux 2023 EC2 instances.

| Server | Role | Private IP |
|---|---|---|
| AnsibleController | SSH Client / Controller | Controller private IP |
| AnsibleNode1 | Managed Node | 172.31.17.247 |
| AnsibleNode2 | Managed Node | 172.31.23.168 |
| AnsibleNode3 | Managed Node | 172.31.31.91 |

**Operating System:** Amazon Linux 2023

**SSH User:** `ec2-user`

**Authentication Method:** SSH Public Key Authentication

**Private Key Name:** `Ansible_key`

**Key Type:** ED25519

---

## 4. Step 1 – Check SSH Availability

Before configuring SSH authentication, verify whether the SSH client is available on the controller.

```bash
ssh -V
```

Example output:

```text
OpenSSH_8.x
```

Check the SSH directory:

```bash
ls -la ~/.ssh/
```

The `.ssh` directory stores SSH-related configuration, keys and known host information.

Common files:

| File | Description |
|---|---|
| `Ansible_key` | Private key |
| `Ansible_key.pub` | Public key |
| `authorized_keys` | Public keys permitted to access this account |
| `known_hosts` | Previously trusted SSH server host keys |
| `config` | SSH client configuration |

---

## 5. Step 2 – Generate an SSH Key Pair

On the Ansible Controller, generate an ED25519 key pair.

```bash
ssh-keygen -t ed25519 -f ~/.ssh/Ansible_key -C "ansible-controller"
```

Explanation:

| Option | Description |
|---|---|
| `ssh-keygen` | Utility used to generate SSH keys |
| `-t ed25519` | Specifies the key algorithm |
| `-f` | Specifies the key filename |
| `-C` | Adds a comment to identify the key |

When prompted for a passphrase, you can configure one for additional protection.

The generated files:

```text
~/.ssh/
    |
    |-- Ansible_key
    |-- Ansible_key.pub
```

- `Ansible_key` → Private key.
- `Ansible_key.pub` → Public key.

Verify:

```bash
ls -l ~/.ssh/Ansible_key*
```

Display the public key:

```bash
cat ~/.ssh/Ansible_key.pub
```

**Security note:** Never copy the private key to managed nodes. Only the public key should be distributed.

---

## 6. Step 3 – Configure Public Key on Managed Nodes

The public key must be added to the remote user's `authorized_keys` file.

For this lab, we have three managed nodes.

### On Node 1

Connect to Node 1 using your existing EC2 access method.

```bash
ssh ec2-user@172.31.17.247
```

Create the SSH directory if it does not exist:

```bash
mkdir -p ~/.ssh
```

Set directory permissions:

```bash
chmod 700 ~/.ssh
```

Open the authorized keys file:

```bash
vi ~/.ssh/authorized_keys
```

Paste the contents of the controller's:

```text
Ansible_key.pub
```

Save and exit.

Set file permissions:

```bash
chmod 600 ~/.ssh/authorized_keys
```

### Repeat on Node 2

```bash
ssh ec2-user@172.31.23.168
```

Add the same public key to:

```bash
~/.ssh/authorized_keys
```

Set permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

### Repeat on Node 3

```bash
ssh ec2-user@172.31.31.91
```

Add the same public key to:

```bash
~/.ssh/authorized_keys
```

Set permissions:

```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**Important:** The public key must be added to the correct Linux user's `authorized_keys` file on every managed node.

---

## 7. Step 4 – Test SSH Without Specifying the Private Key

Return to the Ansible Controller.

First, try:

```bash
ssh ec2-user@172.31.17.247
```

You may receive:

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

Why?

By default, SSH searches standard private key filenames and configured identity sources. It does not automatically search every arbitrarily named private key in `~/.ssh`.

Our private key is named:

```text
~/.ssh/Ansible_key
```

Therefore, specify it explicitly.

```bash
ssh -i ~/.ssh/Ansible_key ec2-user@172.31.17.247
```

Now authentication should succeed.

### Understanding the command

| Parameter | Explanation |
|---|---|
| `ssh` | SSH client command |
| `-i` | Specifies the identity/private key file |
| `~/.ssh/Ansible_key` | Private key location |
| `ec2-user` | Remote Linux username |
| `172.31.17.247` | Managed node private IP |

---

## 8. Step 5 – Configure SSH Client Configuration

Instead of specifying the IP address, username and private key every time, we can configure SSH aliases.

SSH reads client configuration from:

```bash
~/.ssh/config
```

Create or edit the file:

```bash
vi ~/.ssh/config
```

Add the following configuration:

```sshconfig
Host AnsibleNode1
    HostName 172.31.17.247
    User ec2-user
    IdentityFile ~/.ssh/Ansible_key

Host AnsibleNode2
    HostName 172.31.23.168
    User ec2-user
    IdentityFile ~/.ssh/Ansible_key

Host AnsibleNode3
    HostName 172.31.31.91
    User ec2-user
    IdentityFile ~/.ssh/Ansible_key
```

### Understanding each directive

| Directive | Description |
|---|---|
| `Host` | Defines a convenient SSH alias |
| `HostName` | Actual IP address or DNS hostname |
| `User` | Remote Linux username |
| `IdentityFile` | Private key used for authentication |

For example:

```sshconfig
Host AnsibleNode1
    HostName 172.31.17.247
    User ec2-user
    IdentityFile ~/.ssh/Ansible_key
```

When we execute:

```bash
ssh AnsibleNode1
```

SSH automatically resolves the alias into:

```text
IP Address    : 172.31.17.247
Username      : ec2-user
Private Key   : ~/.ssh/Ansible_key
```

We no longer need to specify these parameters manually.

### Set appropriate permissions

On the controller:

```bash
chmod 600 ~/.ssh/config
chmod 600 ~/.ssh/Ansible_key
```

---

## 9. Step 6 – Connect to All Three Managed Nodes

Now we can connect using simple SSH aliases.

### Connect to Node 1

```bash
ssh AnsibleNode1
```

### Connect to Node 2

```bash
ssh AnsibleNode2
```

### Connect to Node 3

```bash
ssh AnsibleNode3
```

No need to specify:

- Username.
- IP address.
- Private key path.

All these details are automatically retrieved from `~/.ssh/config`.

### Verify all nodes from the controller

Instead of logging in individually, execute:

```bash
for node in AnsibleNode1 AnsibleNode2 AnsibleNode3
do
    echo "Connecting to $node"
    ssh "$node" hostname
done
```

Expected output (actual hostnames may differ):

```text
Connecting to AnsibleNode1
ip-172-31-17-247

Connecting to AnsibleNode2
ip-172-31-23-168

Connecting to AnsibleNode3
ip-172-31-31-91
```

This confirms that the SSH configuration works for all three nodes.

---

## 10. Step 7 – Verify Effective SSH Configuration

We can inspect the configuration SSH uses for a particular alias.

```bash
ssh -G AnsibleNode1 | grep -E 'hostname|user|identityfile'
```

Expected output:

```text
user ec2-user
hostname 172.31.17.247
identityfile ~/.ssh/Ansible_key
```

This is useful when troubleshooting SSH configuration issues.

---

## 11. Step 8 – SSH Debugging and Troubleshooting

SSH provides debugging options to identify authentication and connectivity problems.

### Issue 1 – Permission denied

Error:

```text
Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
```

Possible reasons:

1. Incorrect private key.
2. Public key missing from `authorized_keys`.
3. Incorrect username.
4. Incorrect SSH file permissions.
5. Incorrect private key configuration.

Troubleshooting:

On the controller:

```bash
ls -l ~/.ssh/Ansible_key
```

On the managed node:

```bash
ls -ld ~/.ssh
ls -l ~/.ssh/authorized_keys
```

Expected permissions:

```text
.ssh                 700
authorized_keys     600
```

### Issue 2 – SSH connection timeout

Error:

```text
ssh: connect to host 172.31.17.247 port 22: Connection timed out
```

Possible reasons:

1. Security Group does not allow inbound SSH.
2. Network connectivity issue.
3. Incorrect private IP address.
4. Instance is stopped or unreachable.

Check connectivity:

```bash
nc -zv 172.31.17.247 22
```

For AWS EC2, verify:

- Node's Security Group allows inbound TCP port 22.
- The source is the controller's Security Group or controller private IP.
- Both instances have network connectivity through their VPC networking configuration.

### Issue 3 – SSH verbose debugging

Execute:

```bash
ssh -v AnsibleNode1
```

For more detailed debugging:

```bash
ssh -vvv AnsibleNode1
```

Useful messages include:

```text
Offering public key
Server accepts key
Authenticated to 172.31.17.247
```

These messages help identify where authentication succeeds or fails.

---

## 12. Step 9 – Understanding SSH Files and Their Responsibilities

| File | Controller | Managed Node |
|---|---|---|
| `Ansible_key` | Private key | Not required |
| `Ansible_key.pub` | Public key | Not required as a separate file |
| `authorized_keys` | Optional | Contains permitted public keys |
| `config` | Defines SSH aliases | Usually not required |
| `known_hosts` | Stores trusted server host keys | Not relevant to client configuration |

### Important security practices

1. Never share private keys.
2. Use appropriate file permissions.
3. Protect private keys with passphrases where practical.
4. Restrict SSH access through Security Groups.
5. Remove obsolete public keys from `authorized_keys`.
6. Verify server host keys instead of blindly trusting unknown hosts.
7. Use dedicated automation accounts and least-privilege access in production.

---

## 13. Step 10 – Integrating SSH Configuration with Ansible

One of the main benefits of this setup is that Ansible can use the SSH client configuration.

Ansible uses SSH as its default connection mechanism for Linux managed nodes.

We can configure our inventory to use the SSH aliases.

Create or edit:

```bash
vi inventory/hosts
```

Add:

```ini
[managed_nodes]
AnsibleNode1
AnsibleNode2
AnsibleNode3
```

Now execute:

### Test connectivity to all nodes

```bash
ansible managed_nodes -i inventory/hosts -m ping
```

### Execute a command on all nodes

```bash
ansible managed_nodes -i inventory/hosts -m command -a "hostname"
```

### Check disk utilization on all nodes

```bash
ansible managed_nodes -i inventory/hosts -m command -a "df -Th"
```

Because the aliases are configured in `~/.ssh/config`, SSH can resolve the IP address, username and private key automatically.

**Note:** Ansible must run under the same Linux account that owns the SSH configuration, or the SSH configuration must be explicitly made available to the account running Ansible.

---

## 14. Important Concepts to Remember

| Concept | Explanation |
|---|---|
| SSH | Secure remote connectivity protocol |
| SSH Key Pair | Private key and public key |
| Private Key | Remains on the client/controller |
| Public Key | Added to the managed node |
| `authorized_keys` | Stores permitted public keys |
| `ssh-keygen` | Generates SSH key pairs |
| `-i` | Specifies the private key |
| `~/.ssh/config` | Stores client-side SSH configuration |
| `Host` | Defines an SSH alias |
| `HostName` | Actual server IP or hostname |
| `IdentityFile` | Specifies the private key |
| `known_hosts` | Stores trusted server host keys |
| `ssh -v` | Enables verbose SSH debugging |

---

## 15. Final Hands-on Practice Checklist

- [ ] Verified SSH client availability.
- [ ] Generated ED25519 SSH key pair.
- [ ] Understood private key and public key.
- [ ] Added the public key to Node 1.
- [ ] Added the public key to Node 2.
- [ ] Added the public key to Node 3.
- [ ] Verified SSH permissions.
- [ ] Tested SSH using `-i`.
- [ ] Configured `~/.ssh/config`.
- [ ] Created three SSH aliases.
- [ ] Connected to all three nodes without specifying IP addresses.
- [ ] Tested SSH using a shell loop.
- [ ] Practiced SSH debugging.
- [ ] Integrated SSH aliases with Ansible inventory.
- [ ] Verified Ansible connectivity using the ping module.

---

## Conclusion

SSH Public Key Authentication is a fundamental requirement for Linux administration, cloud infrastructure management and DevOps automation.

By configuring SSH key-based authentication and client-side aliases, we can simplify connectivity to multiple Linux servers without repeatedly specifying private key paths, usernames and IP addresses.

This configuration also provides a foundation for Ansible automation, where a central controller communicates with multiple managed nodes through SSH.

**Next learning topic:** Understanding SSH authentication internals, SSH agent (`ssh-agent` and `ssh-add`), and managing SSH keys securely in production environments.