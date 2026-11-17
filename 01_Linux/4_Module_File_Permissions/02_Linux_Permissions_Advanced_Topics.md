# Linux Permissions — Advanced Topics

This section covers advanced Linux permission and access-control concepts required for **DevOps, Cloud, SRE, and Linux administration** roles.

The goal is not just to memorize commands, but to understand **how Linux decides access, how permissions fail in production, and how to troubleshoot them safely**.

---

# 1. Symbolic Permissions with `chmod`

Numeric permissions are not the only way to modify permissions.

```bash
chmod u+x deploy.sh
chmod g+w application.log
chmod o-r secret.txt
chmod a+r public.txt
```

## Permission categories

```text
u = user/owner
g = group
o = others
a = all
```

## Operators

```text
+ = add permission
- = remove permission
= = set permission exactly
```

### Examples

```bash
chmod u+x script.sh
```

Adds execute permission for the owner.

```bash
chmod g-w app.log
```

Removes write permission from the group.

```bash
chmod o-r secret.txt
```

Removes read permission from others.

```bash
chmod u=rwx,g=rx,o= app.sh
```

Sets the permissions explicitly.

---

# 2. Advanced Directory Permissions

Directory permissions behave differently from file permissions.

| Permission | Directory Meaning |
|---|---|
| `r` | List directory contents |
| `w` | Create, delete, rename entries |
| `x` | Enter/traverse the directory |

The `x` permission is particularly important.

For example:

```bash
chmod 600 /data
```

A user may technically have read permission but still be unable to access files inside because the directory does not have the required execute permission.

## Important concept

For a path such as:

```text
/var/www/app/config.yaml
```

Linux must be able to traverse:

```text
/
 ↓
/var
 ↓
/var/www
 ↓
/var/www/app
 ↓
config.yaml
```

A missing `x` permission on any required directory can result in:

```text
Permission denied
```

This is one of the most common Linux permission troubleshooting scenarios.

---

# 3. `umask`

`umask` controls the default permissions assigned when new files and directories are created.

Check the current value:

```bash
umask
```

Example:

```text
0022
```

Typical base permissions are:

```text
Files       → 666
Directories → 777
```

The `umask` removes permissions from these defaults.

For example:

```bash
umask 022
```

Typically results in:

```text
Files       → 644
Directories → 755
```

Therefore:

```text
File:
666 - umask 022 → 644

Directory:
777 - umask 022 → 755
```

## Common values

```text
022 → commonly used
027 → more restrictive
077 → private
```

`umask` is important for:

- Application logs
- Deployment files
- Temporary files
- Configuration files
- CI/CD pipelines
- Service accounts

---

# 4. Special Permissions

Linux provides three special permission mechanisms:

```text
SUID
SGID
Sticky Bit
```

Their numeric values are:

```text
SUID       → 4000
SGID       → 2000
Sticky Bit → 1000
```

---

# 5. SUID

SUID means **Set User ID**.

When SUID is applied to an executable, the process runs with the permissions of the **file owner** rather than the user who launched it.

Example:

```bash
chmod 4755 program
```

You may see:

```text
-rwsr-xr-x
```

The `s` represents SUID.

A classic example is:

```bash
ls -l /usr/bin/passwd
```

The important security concept is:

```text
Normal executable:

User
 ↓
Process runs with user's privileges


SUID executable:

User
 ↓
Process
 ↓
runs with file owner's effective privileges
```

Because SUID can provide elevated privileges, SUID binaries must be carefully controlled.

---

# 6. SGID

SGID means **Set Group ID**.

SGID behaves differently depending on whether it is applied to a file or directory.

## SGID on an executable

The process runs with the file's group identity.

Example:

```bash
chmod 2755 program
```

You may see:

```text
-rwxr-sr-x
```

---

## SGID on a directory

This is particularly useful in DevOps environments.

When SGID is enabled on a directory, newly created files and directories inherit the directory's group.

Example:

```bash
chmod 2775 /opt/project
```

Suppose:

```text
/opt/project
Owner → deploy
Group → devops
```

Then files created inside the directory inherit the `devops` group.

This is useful for shared application and deployment directories.

---

# 7. Sticky Bit

The Sticky Bit is commonly used on shared directories.

Numeric value:

```text
1000
```

Example:

```bash
chmod 1777 /shared
```

You may see:

```text
drwxrwxrwt
```

The `t` represents the Sticky Bit.

A classic example is:

```bash
ls -ld /tmp
```

The purpose is:

```text
Multiple users
      ↓
Shared directory
      ↓
Users can create their own files
      ↓
Users generally cannot delete/rename
other users' files
```

This prevents users from freely deleting files belonging to other users in a shared writable directory.

---

# 8. SUID vs SGID vs Sticky Bit

| Feature | Purpose |
|---|---|
| SUID | Executable runs with file owner's identity |
| SGID on file | Executable runs with file group's identity |
| SGID on directory | New entries inherit directory group |
| Sticky Bit | Restricts deletion/rename in shared directories |

Remember:

```text
SUID       → User identity
SGID       → Group identity / group inheritance
Sticky Bit → Deletion protection
```

---

# 9. Access Control Lists (ACL)

Traditional Linux permissions provide:

```text
Owner
Group
Others
```

But sometimes you need more granular access.

For example:

```text
pradeep → rwx
devops  → r-x
john    → rw-
others  → ---
```

Traditional permissions cannot represent this cleanly.

ACLs solve this problem.

---

# 10. `getfacl`

View ACL information:

```bash
getfacl app.txt
```

Example:

```text
user::rwx
group::r-x
user:john:rw-
mask::rwx
other::---
```

This means a specific user named `john` has additional permissions.

---

# 11. `setfacl`

Give a specific user access:

```bash
setfacl -m u:john:rw app.txt
```

Give a group access:

```bash
setfacl -m g:developers:r app.txt
```

Remove a user ACL:

```bash
setfacl -x u:john app.txt
```

Remove all extended ACL entries:

```bash
setfacl -b app.txt
```

---

# 12. Default ACL

Default ACLs are useful for directories.

They determine the ACL permissions inherited by newly created files and directories.

Example:

```bash
setfacl -d -m g:developers:rwx /opt/project
```

Now newly created entries under the directory can inherit the configured default ACL.

This is useful for:

- Shared deployment directories
- Development environments
- CI/CD workspaces
- Application directories

---

# 13. ACL Mask

The ACL mask limits the effective permissions of:

```text
Named users
Named groups
Owning group
```

View it with:

```bash
getfacl file.txt
```

You may see:

```text
mask::r-x
```

Even if a named ACL entry says:

```text
user:john:rwx
```

the effective permission can be limited by the ACL mask.

Understanding the ACL mask is important when troubleshooting unexpected permissions.

---

# 14. `sudo` vs File Permissions

`sudo` and Linux file permissions are different mechanisms.

### File permissions

Control:

```text
Who can read?
Who can write?
Who can execute?
```

### `sudo`

Controls:

```text
Which commands a user is allowed to execute
with elevated privileges?
```

Example:

```bash
sudo systemctl restart nginx
```

Configuration is commonly managed through:

```text
/etc/sudoers
/etc/sudoers.d/
```

The principle should be:

```text
Least privilege
```

Avoid giving unrestricted root access when only one administrative command is required.

---

# 15. Permission Troubleshooting

When an application reports:

```text
Permission denied
```

Do not immediately run:

```bash
chmod 777
```

Instead investigate systematically.

## Step 1 — Identify the process/user

```bash
ps -ef
```

or:

```bash
ps -ef | grep nginx
```

Ask:

```text
Which user is running the process?
```

---

## Step 2 — Check ownership and permissions

```bash
ls -l /path/to/file
```

Example:

```text
-rw-r----- 1 appuser devops config.yaml
```

---

## Step 3 — Check the user's groups

```bash
id appuser
```

or:

```bash
groups appuser
```

---

## Step 4 — Check every directory in the path

```bash
namei -l /var/www/app/config.yaml
```

This is extremely useful when the file itself looks correct but access still fails.

---

## Step 5 — Check ACLs

```bash
getfacl /var/www/app/config.yaml
```

---

## Step 6 — Check SELinux/AppArmor

On SELinux systems:

```bash
getenforce
sestatus
ls -Z /path/to/file
```

---

# 16. `namei`

`namei` breaks a path into its individual components.

Example:

```bash
namei -l /var/www/app/config.yaml
```

Conceptually:

```text
/
 ↓
var
 ↓
www
 ↓
app
 ↓
config.yaml
```

This helps identify which directory in the path is preventing traversal.

For production troubleshooting, `namei -l` is an extremely useful command.

---

# 17. `stat`

`stat` provides detailed metadata about a file.

```bash
stat app.txt
```

It can show:

```text
File
Size
Permissions
Owner
Group
Inode
Access time
Modify time
Change time
```

Useful when `ls -l` does not provide enough information.

---

# 18. Finding Files by Permission

The `find` command can search for files based on permissions.

Example:

```bash
find /var/www -type f -perm 644
```

Find files with at least the specified permission bits:

```bash
find /var/www -type f -perm -644
```

Find SUID files:

```bash
find / -type f -perm -4000 2>/dev/null
```

Find SGID files:

```bash
find / -type f -perm -2000 2>/dev/null
```

This is useful for security auditing.

---

# 19. Recursive Permissions

Commands such as:

```bash
chmod -R
chown -R
```

apply changes recursively.

Example:

```bash
chown -R appuser:devops /opt/application
```

Be extremely careful with:

```bash
chmod -R 777
```

Blindly changing permissions recursively can:

- Expose sensitive files
- Break applications
- Create security vulnerabilities
- Change permissions on files that require restrictive access

Always understand the directory structure before using recursive commands.

---

# 20. Symbolic Links and Permissions

Create a symbolic link:

```bash
ln -s original.txt link.txt
```

Check it:

```bash
ls -l link.txt
```

You may see:

```text
lrwxrwxrwx link.txt -> original.txt
```

The permissions shown on the symbolic link itself are not what normally control access to the target.

Access is determined by:

```text
Target file permissions
+
Parent directory traversal permissions
+
ACLs
+
Security mechanisms
```

---

# 21. Linux Capabilities

Traditional Linux security often treats root as highly privileged.

Linux capabilities divide some privileged operations into smaller capabilities.

Examples include:

```text
CAP_CHOWN
CAP_DAC_OVERRIDE
CAP_NET_ADMIN
CAP_NET_BIND_SERVICE
```

View capabilities:

```bash
getcap /usr/bin/ping
```

Set a capability:

```bash
setcap CAP_NET_BIND_SERVICE=+ep application
```

Capabilities are particularly important when working with:

- Docker
- Kubernetes
- Containers
- Security hardening
- Privileged applications

The key concept:

```text
Root privileges
      ↓
Can be divided into
smaller capabilities
```

---

# 22. SELinux and AppArmor

Traditional Linux permissions are commonly referred to as **Discretionary Access Control (DAC)**.

Examples:

```text
chmod
chown
ACL
```

Security frameworks such as SELinux provide **Mandatory Access Control (MAC)**.

Therefore:

```text
Linux permissions → Allow
        ↓
SELinux policy → Deny
        ↓
Access denied
```

This explains an important production scenario:

> "The file permissions look correct, but the application still receives Permission denied."

On SELinux systems, useful commands include:

```bash
getenforce
sestatus
ls -Z
```

You should understand the concept before attempting to memorize SELinux policy commands.

---

# 23. Least Privilege

A production system should follow the principle of:

```text
Give only the permissions required
to perform the task.
```

Avoid:

```bash
chmod 777 application
```

Prefer:

```text
Correct owner
+
Correct group
+
Minimum required permissions
+
ACL when necessary
+
SELinux/AppArmor where applicable
```

Example:

```text
Application configuration
        ↓
Owned by application user
        ↓
Readable only by required users/group
        ↓
Not writable by everyone
```

---

# 24. Production Scenario: Shared Application Directory

Suppose multiple developers and deployment processes need access to:

```text
/opt/application
```

A better design is:

```text
devops group
      ↓
/opt/application
      ↓
SGID directory
      ↓
New files inherit devops group
```

Instead of:

```bash
chmod -R 777 /opt/application
```

This provides controlled collaboration while maintaining security.

---

# 25. Production Scenario: Nginx Permission Denied

Suppose Nginx reports:

```text
Permission denied
```

A DevOps engineer should investigate:

```text
1. Which user is Nginx running as?
2. Who owns the file?
3. What is the file's group?
4. Is the Nginx user a member of that group?
5. Do parent directories have x permission?
6. Is there an ACL?
7. Is SELinux/AppArmor blocking access?
8. Are there filesystem/mount restrictions?
```

Useful commands:

```bash
ps -ef | grep nginx
ls -l /path/to/file
id nginx
namei -l /path/to/file
getfacl /path/to/file
```

This is much better than blindly changing permissions.

---

# 26. Production Scenario: CI/CD Deployment

A deployment pipeline may run as:

```text
jenkins
gitlab-runner
github-actions runner
deploy
```

The deployment user should have only the permissions required to:

```text
Pull artifacts
 ↓
Copy application
 ↓
Modify required files
 ↓
Restart required service
```

It should not automatically receive unrestricted root access.

A common design is:

```text
Deployment user
      ↓
Specific group permissions
      +
Specific sudo rules
      +
Application directory ownership
```

---

# 27. Production Scenario: SSH Private Keys

SSH private keys should have restrictive permissions.

Typical example:

```bash
chmod 600 ~/.ssh/id_ed25519
```

Public keys can normally be less restrictive:

```bash
chmod 644 ~/.ssh/id_ed25519.pub
```

The key principle is:

```text
Private key → protect carefully
Public key  → can be shared
```

---

# 28. Permission Troubleshooting Decision Tree

When you see:

```text
Permission denied
```

think:

```text
Permission denied
       │
       ▼
Who is accessing it?
       │
       ▼
What user/group does the process use?
       │
       ▼
Who owns the resource?
       │
       ▼
Does owner/group/others apply?
       │
       ▼
Check parent directory x permissions
       │
       ▼
Check ACL
       │
       ▼
Check SELinux/AppArmor
       │
       ▼
Check filesystem/mount restrictions
       │
       ▼
Fix the minimum required permission
```

---

# 29. Advanced Commands Cheat Sheet

```bash
# Permissions
ls -l file
stat file

# Ownership
chown user file
chown user:group file
chgrp group file

# chmod
chmod 755 file
chmod u+x file
chmod g-w file

# Groups
id user
groups user

# umask
umask
umask 027

# ACL
getfacl file
setfacl -m u:john:rw file
setfacl -m g:devops:r file
setfacl -d -m g:devops:rwx directory

# Special permissions
chmod 4755 file    # SUID
chmod 2755 dir     # SGID
chmod 1777 dir     # Sticky Bit

# Troubleshooting
namei -l /path/to/file
find / -type f -perm -4000 2>/dev/null

# Capabilities
getcap file
setcap CAP_NET_BIND_SERVICE=+ep file

# SELinux
getenforce
sestatus
ls -Z
```

---

# 30. What You Should Be Able to Explain in an Interview

After completing this section, you should be able to answer:

1. Why does a directory need `x` permission?
2. Why can a user have read permission but still receive `Permission denied`?
3. Does Linux combine permissions from all supplementary groups?
4. What is `umask`?
5. What is SUID?
6. What is SGID?
7. Why is SGID useful on shared directories?
8. What is the Sticky Bit?
9. Why does `/tmp` use the Sticky Bit?
10. What problem do ACLs solve?
11. What is the ACL mask?
12. What is the difference between `sudo` and file permissions?
13. How would you troubleshoot `Permission denied`?
14. Why would you use `namei -l`?
15. How would you find SUID files?
16. Why is `chmod -R 777` dangerous?
17. What are Linux capabilities?
18. What is the difference between DAC and MAC?
19. Why can SELinux deny access even when `ls -l` looks correct?
20. How would you design permissions for a shared deployment directory?

---

# 31. DevOps Skill Target

The goal is not:

```text
Memorize chmod commands
```

The goal is:

```text
Understand
   ↓
Analyze
   ↓
Troubleshoot
   ↓
Design secure permissions
   ↓
Fix production problems
   ↓
Apply least privilege
```

For a DevOps/Cloud engineer, Linux permissions should ultimately connect to:

```text
Linux
 ↓
Users & Groups
 ↓
Permissions
 ↓
ACL
 ↓
sudo
 ↓
SELinux/AppArmor
 ↓
Processes & Services
 ↓
Nginx / SSH / Applications
 ↓
CI/CD
 ↓
Docker
 ↓
Kubernetes
 ↓
Cloud infrastructure
```

This is the level at which Linux permissions become a **real DevOps skill rather than just a collection of `chmod` commands**.
