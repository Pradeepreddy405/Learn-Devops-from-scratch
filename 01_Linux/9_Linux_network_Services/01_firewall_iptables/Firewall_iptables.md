# Linux Firewall: iptables vs firewalld

## 1. What is a Firewall?

A firewall controls network traffic entering and leaving a Linux server.

**Example:** Your Linux server runs Apache on port `80`. A firewall can allow HTTP traffic on port 80 and block unwanted traffic on port 8080.

## 2. What is iptables?

`iptables` is a Linux command-line tool used to create firewall rules.

### Example 1: Check firewall rules

```bash
sudo iptables -L -n -v
```

This command displays existing firewall rules.

### Example 2: Allow HTTP traffic

```bash
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

Explanation:

- `-A INPUT` — Add a rule to the incoming traffic chain.
- `-p tcp` — Match TCP traffic.
- `--dport 80` — Match destination port 80.
- `-j ACCEPT` — Allow matching traffic.

### Example 3: Block traffic on port 8080

```bash
sudo iptables -A INPUT -p tcp --dport 8080 -j DROP
```

This drops matching incoming TCP packets destined for port 8080.

**Note:** These rules are examples. Existing rules and their order can affect the result. Do not change production firewall rules without checking the current configuration.

## 3. What is firewalld?

`firewalld` is a Linux firewall management service. It makes firewall configuration easier by allowing you to manage services, ports, and zones.

### Example 1: Check firewalld status

```bash
sudo systemctl status firewalld
```

This shows whether the firewalld service is running.

### Example 2: Check allowed services and ports

```bash
sudo firewall-cmd --list-all
```

This displays the configuration for the default active zone.

### Example 3: Allow HTTP traffic temporarily

```bash
sudo firewall-cmd --add-service=http
```

This allows HTTP traffic in the active zone at runtime. The change is not automatically permanent.

### Example 4: Allow port 8080 permanently

```bash
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload
```

Verify the rule:

```bash
sudo firewall-cmd --query-port=8080/tcp
```

A result of `yes` means the port is configured as allowed in the permanent configuration.

## 4. What is Netfilter?

Netfilter is the framework in the Linux kernel that handles packet filtering and related network operations.

- `iptables` configures rules through the iptables interface.
- `firewalld` manages firewall rules through a higher-level interface.
- Netfilter processes packets according to the applicable rules.

## 5. iptables vs firewalld

| iptables | firewalld |
|---|---|
| Command-line rule management | Higher-level firewall management |
| Uses tables and chains | Uses zones, services, and ports |
| Rules are configured individually | Rules can be managed dynamically |
| Persistence needs appropriate configuration | Supports permanent rules |

Modern Linux systems may use the nftables backend. Check your distribution before assuming which backend is active.

## 6. Practical Example: Troubleshooting Port 6400

Suppose Apache is running on port `6400`, but you cannot access it remotely.

### Step 1: Check whether the application is listening

```bash
sudo ss -lntp | grep ':6400'
```

### Step 2: Test locally on the application server

```bash
curl -v http://localhost:6400
```

### Step 3: Check firewalld

```bash
sudo systemctl is-active firewalld
sudo firewall-cmd --list-all
```

### Step 4: Check iptables, if available

```bash
sudo iptables -L -n -v
```

### Step 5: Test from another server

```bash
curl -v http://<APP_SERVER_PRIVATE_IP>:6400
```

Replace `<APP_SERVER_PRIVATE_IP>` with the actual private IP address.

Remember: `localhost` always refers to the machine where the command is executed.

If local access works but remote access fails, investigate the listening address, firewall rules, AWS security groups, network ACLs, and routing.

## 7. Important Commands to Remember

```bash
# Check firewalld status
sudo systemctl is-active firewalld

# List firewalld rules
sudo firewall-cmd --list-all

# List iptables rules
sudo iptables -L -n -v

# Check listening ports
sudo ss -lntp

# Test a local application
curl -v http://localhost:6400
```

## Conclusion

A firewall protects Linux servers by controlling network traffic.

**Remember:**
- `iptables` — Configure firewall rules.
- `firewalld` — Manage firewall rules more easily.
- `Netfilter` — Kernel framework that processes network packets.

Learn to inspect existing rules and troubleshoot connectivity before making firewall changes on production servers.
