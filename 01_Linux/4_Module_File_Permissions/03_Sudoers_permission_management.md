# Linux User Management – Sudo Access Using `/etc/sudoers.d/`

## Project Overview

As a Linux System Administrator, one of the important responsibilities is managing user permissions and controlling administrative access to Linux servers.

In this project, we configure sudo privileges for individual users using separate files inside `/etc/sudoers.d/` instead of adding users to the `wheel` group.

This approach helps administrators manage user-level permissions independently and maintain better access control.

## Environment

| Component | Details |
|---|---|
| Cloud Platform | AWS EC2 |
| Operating System | Amazon Linux 2023 |
| User Account | senior_engineer |
| Access Type | Superuser (sudo) |
| Configuration Directory | `/etc/sudoers.d/` |
| Configuration Tool | `visudo` |

## Objectives

- Create and manage Linux user accounts.
- Provide sudo access to authorized users.
- Configure individual sudoers files.
- Understand Linux sudo permissions.
- Validate sudoers configurations.
- Test administrative access.
- Follow Linux security best practices.

## 1. Verify Linux Operating System

```bash
cat /etc/os-release
```

## 2. Check Whether the User Exists

```bash
id senior_engineer
```

If the user does not exist, create the account:

```bash
sudo useradd -m senior_engineer
```

Set the user's password:

```bash
sudo passwd senior_engineer
```

## 3. Create an Individual Sudoers File

Instead of modifying the default sudoers configuration, create a separate file for the user.

```bash
sudo visudo -f /etc/sudoers.d/senior_engineer
```

Add the following configuration:

```bash
senior_engineer ALL=(ALL) ALL
```

### Understanding the Configuration

| Configuration | Description |
|---|---|
| senior_engineer | Linux username |
| ALL | All hosts |
| (ALL) | Execute commands as any user |
| ALL | Execute all commands |

This configuration provides the user with unrestricted sudo privileges, subject to sudo's authentication and policy settings.

## 4. Configure File Permissions

Set the appropriate permissions:

```bash
sudo chmod 0440 /etc/sudoers.d/senior_engineer
```

The sudoers file should not be writable by unauthorized users.

## 5. Validate Sudoers Configuration

Run:

```bash
sudo visudo -c
```

Expected output:

```text
/etc/sudoers: parsed OK
/etc/sudoers.d/senior_engineer: parsed OK
```

This confirms that the sudoers configuration has valid syntax.

## 6. Verify User Sudo Permissions

Switch to the senior engineer account:

```bash
su - senior_engineer
```

Check sudo privileges:

```bash
sudo -l
```

Test administrative access:

```bash
sudo whoami
```

Expected output:

```text
root
```

This confirms that the user can execute commands with root privileges.

## 7. Example: Different Levels of Sudo Access

Administrators can configure different levels of access depending on employee responsibilities.

### Full Administrative Access

```bash
senior_engineer ALL=(ALL) ALL
```

### Passwordless Administrative Access

```bash
senior_engineer ALL=(ALL) NOPASSWD: ALL
```

### Specific Command Access

Example:

```bash
developer ALL=(root) /usr/bin/systemctl restart nginx
```

This permits the developer to restart Nginx through sudo without granting unrestricted administrative access.

Always validate command paths and consider the risks of command arguments, wildcards, and privileged service configurations before deploying restricted policies.

## 8. Remove Sudo Access

If the employee leaves the organization or no longer requires administrative privileges, remove the individual sudoers file:

```bash
sudo rm /etc/sudoers.d/senior_engineer
```

Validate the remaining configuration:

```bash
sudo visudo -c
```

**Note:** Removing the file revokes the privileges granted through that file. Check other sudoers rules and group memberships as well.

## 9. Important Linux Administration Commands

| Command | Purpose |
|---|---|
| `id username` | Check user and group information |
| `useradd -m username` | Create a user |
| `passwd username` | Set or change password |
| `visudo -f FILE` | Edit a sudoers file safely |
| `chmod 0440 FILE` | Set sudoers file permissions |
| `visudo -c` | Validate sudoers configuration |
| `sudo -l` | Display sudo privileges |
| `sudo whoami` | Test administrative access |
| `rm FILE` | Remove a sudoers configuration file |

## 10. Security Best Practices

1. Never share root account credentials between employees.
2. Grant sudo access only after proper authorization.
3. Prefer individual sudoers files for independent access policies.
4. Always use `visudo` to edit sudoers configurations.
5. Validate configurations using `visudo -c`.
6. Avoid unnecessary `NOPASSWD: ALL` permissions.
7. Follow the principle of least privilege.
8. Periodically review sudo access.
9. Remove privileges when they are no longer required.
10. Maintain an audit trail of administrative access changes.

## Conclusion

In this project, we learned how to manage Linux administrative privileges using individual sudoers configuration files.

Instead of depending only on group-based sudo access, we used `/etc/sudoers.d/` to configure permissions independently for individual users.

This is an important Linux System Administration practice for managing access control in enterprise environments.

## Key Learning

**Topics Covered:**
- Linux User Management
- Sudo and Root Privileges
- Sudoers Configuration
- `/etc/sudoers.d/`
- Linux File Permissions
- Access Control
- Security Best Practices
- Administrative Privilege Management

**Platform:** AWS EC2 – Amazon Linux 2023