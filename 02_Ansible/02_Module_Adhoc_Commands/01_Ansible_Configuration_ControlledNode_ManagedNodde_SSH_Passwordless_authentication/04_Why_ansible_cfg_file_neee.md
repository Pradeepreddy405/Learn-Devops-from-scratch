## Why Do We Need an `ansible.cfg` File?

Ansible can execute ad-hoc commands and playbooks without an `ansible.cfg` file. However, as infrastructure grows, managing Ansible through command-line arguments and individual SSH configurations can become difficult.

The `ansible.cfg` file provides a centralized location to define default Ansible settings, making automation easier to maintain, consistent, and reusable.

### 1. Challenges of Working Without `ansible.cfg`

In our current hands-on lab, we have one Ansible Controller and three Managed Nodes.

We configured SSH passwordless authentication using the controller's `~/.ssh/config` file. Therefore, we can execute commands without explicitly specifying the SSH username and private key.

Example:

```bash
ansible all -i inventory/hosts -m ping
```

Although this works, we face the following challenges as our infrastructure grows.

| Challenge | Explanation |
|---|---|
| Inventory Management | We must repeatedly specify the inventory path using `-i`. |
| SSH User Management | We depend on SSH client configuration or explicitly specify the remote user using `-u