# AWS EC2 MySQL Database Server Setup – Amazon Linux 2023

## Project Overview

This project demonstrates how to provision an AWS EC2 instance with Amazon Linux 2023, configure Linux user authentication, provide passwordless sudo privileges, install MySQL Community Server, and create an Expense Tracker database.

The project covers practical Linux administration, AWS infrastructure provisioning, SSH configuration, sudoers management, DNF repository configuration, MySQL installation, and database management.

---

## Project Requirements

### AWS Infrastructure

| Component | Configuration |
|---|---|
| Cloud Provider | AWS |
| Compute Service | EC2 |
| Operating System | Amazon Linux 2023 |
| Instance Type | t2.micro / t3.micro |
| Storage | 20 GB gp3 |
| Database | MySQL Community Server 8.0 |
| Database Port | 3306 |
| SSH Port | 22 |

### Linux User Configuration

| Property | Value |
|---|---|
| Linux Username | senior_devops_engineer_369 |
| Authentication | Password |
| Sudo Access | Passwordless |
| Sudoers File | /etc/sudoers.d/senior_devops_engineer_369 |

### MySQL Database Configuration

| Property | Value |
|---|---|
| Database Administrator | database_admin_369 |
| Password | DbAdmin@369! |
| Host | localhost |
| Database Name | Expense_Tracker |
| Table Name | expenses |

---

# Task 1: Launch an AWS EC2 Instance

1. Login to the AWS Management Console.
2. Navigate to EC2.
3. Select Launch Instance.

### Instance Configuration

- Name: MYSQL-Database-Server
- AMI: Amazon Linux 2023
- Architecture: 64-bit x86
- Instance Type: t2.micro or t3.micro
- Key Pair: Create or select an existing key pair.
- Storage: 20 GB gp3.
- Network: Default VPC.
- Auto-assign Public IP: Enable if required for SSH access.

### Security Group Configuration

Create a security group named:

`MYSQL-SG`

| Type | Port | Source |
|---|---:|---|
| SSH | 22 | My IP |
| MySQL/Aurora | 3306 | Application server security group, if remote database access is required |

Do not expose MySQL port 3306 publicly.

### Connect to EC2

```bash
ssh -i your-key.pem ec2-user@YOUR_PUBLIC_IP
```

Verify the operating system:

```bash
cat /etc/os-release
```

Update the operating system:

```bash
sudo dnf update -y
```

---

# Task 2: Create a Linux User and Configure Password Authentication

### Step 1: Create the Linux User

```bash
sudo useradd -m senior_devops_engineer_369
```

Verify the user:

```bash
id senior_devops_engineer_369
```

### Step 2: Set the User Password

```bash
sudo passwd senior_devops_engineer_369
```

Enter and confirm the password when prompted.

### Step 3: Backup SSH Configuration

```bash
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup
```

Check for additional SSH configuration files:

```bash
grep -nE '^[[:space:]]*Include' /etc/ssh/sshd_config
```

### Step 4: Configure Password Authentication

Create a separate SSH configuration file:

```bash
sudo vi /etc/ssh/sshd_config.d/00-password-auth.conf
```

Add:

```ini
PasswordAuthentication yes
PubkeyAuthentication no
KbdInteractiveAuthentication no
AuthenticationMethods password
PermitRootLogin no
```

Save and exit.

### Configuration Explanation

| Parameter | Purpose |
|---|---|
| PasswordAuthentication yes | Enables password authentication |
| PubkeyAuthentication no | Disables SSH public-key authentication |
| KbdInteractiveAuthentication no | Disables keyboard-interactive authentication |
| AuthenticationMethods password | Requires password authentication |
| PermitRootLogin no | Prevents direct root SSH login |

### Step 5: Validate SSH Configuration

```bash
sudo sshd -t
```

Verify effective settings:

```bash
sudo sshd -T | grep -E 'passwordauthentication|pubkeyauthentication|kbdinteractiveauthentication|authenticationmethods|permitrootlogin'
```

### Step 6: Restart SSH Service

```bash
sudo systemctl restart sshd
```

Check SSH service:

```bash
sudo systemctl status sshd
```

### Step 7: Test SSH Login

Open another terminal:

```bash
ssh senior_devops_engineer_369@YOUR_PUBLIC_IP
```

Enter the Linux user's password.

Keep your original SSH session open until the new login is confirmed.

---

# Task 3: Configure Passwordless Sudo Privileges

Create a separate sudoers configuration file instead of modifying the main sudoers file.

### Step 1: Create the Sudoers File

```bash
sudo visudo -f /etc/sudoers.d/senior_devops_engineer_369
```

Add:

```bash
senior_devops_engineer_369 ALL=(ALL) NOPASSWD: ALL
```

Save and exit.

### Step 2: Validate Sudoers Configuration

```bash
sudo visudo -c
```

Expected output:

```text
/etc/sudoers: parsed OK
/etc/sudoers.d/senior_devops_engineer_369: parsed OK
```

### Step 3: Test Passwordless Sudo Access

Switch to the newly created user:

```bash
su - senior_devops_engineer_369
```

Execute:

```bash
sudo whoami
```

Expected output:

```text
root
```

Check sudo permissions:

```bash
sudo -l
```

The user should be able to execute sudo commands without entering a password.

---

# Task 4: Check MySQL Repository Availability and Install MySQL Server

### Step 1: Check Configured DNF Repositories

```bash
sudo dnf repolist
```

### Step 2: Search for MySQL Server

```bash
sudo dnf search mysql-server
```

Check package availability:

```bash
sudo dnf list available mysql-server
```

Amazon Linux 2023 may not provide Oracle MySQL Server under the `mysql-server` package name in its default repositories.

### Step 3: Add the Official MySQL Community Repository

Install the MySQL 8.0 Community repository package:

```bash
sudo dnf install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
```

Import the MySQL signing key:

```bash
sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
```

### Step 4: Verify MySQL Repository

```bash
sudo dnf repolist all | grep mysql
```

### Step 5: Install MySQL Community Server

The official MySQL Community Server package name is:

`mysql-community-server`

Install:

```bash
sudo dnf install mysql-community-server -y
```

### Step 6: Verify Installation

```bash
rpm -q mysql-community-server
```

Check the installed MySQL version:

```bash
mysqld --version
```

---

# Task 5: Start and Enable MySQL Service

### Step 1: Start MySQL Service

```bash
sudo systemctl start mysqld
```

### Step 2: Enable MySQL Service at Boot

```bash
sudo systemctl enable mysqld
```

### Step 3: Check MySQL Service Status

```bash
sudo systemctl status mysqld
```

Expected status:

```text
Active: active (running)
```

### Step 4: Verify Service Enablement

```bash
sudo systemctl is-enabled mysqld
```

Expected output:

```text
enabled
```

### Step 5: Verify MySQL Process

```bash
ps -ef | grep mysqld
```

Check whether MySQL is listening on port 3306:

```bash
sudo ss -tulnp | grep 3306
```

---

# Task 6: Create a MySQL Database Administrator

### Step 1: Find the Temporary MySQL Root Password

On a fresh MySQL Community Server installation:

```bash
sudo grep 'temporary password' /var/log/mysqld.log
```

Copy the generated temporary password.

### Step 2: Login as MySQL Root

```bash
mysql -u root -p
```

Enter the temporary password.

### Step 3: Change MySQL Root Password

Inside the MySQL shell:

```sql
ALTER USER 'root'@'localhost'
IDENTIFIED BY 'YourStrongRootPassword@123';
```

Replace the example with your own strong root password.

### Step 4: Create the Database Administrator

Execute:

```sql
CREATE USER 'database_admin_369'@'localhost'
IDENTIFIED BY 'DbAdmin@369!';
```

### Step 5: Verify MySQL User

```sql
SELECT user, host
FROM mysql.user
WHERE user = 'database_admin_369';
```

Expected output:

```text
database_admin_369 | localhost
```

Exit MySQL:

```sql
EXIT;
```

---

# Task 7: Create the Expense_Tracker Database

### Step 1: Login as MySQL Root

```bash
mysql -u root -p
```

### Step 2: Create the Database

```sql
CREATE DATABASE IF NOT EXISTS Expense_Tracker;
```

### Step 3: Grant Database Privileges

```sql
GRANT ALL PRIVILEGES
ON Expense_Tracker.*
TO 'database_admin_369'@'localhost';
```

### Step 4: Verify Granted Privileges

```sql
SHOW GRANTS FOR 'database_admin_369'@'localhost';
```

### Step 5: Exit MySQL

```sql
EXIT;
```

### Step 6: Login Using the Database Administrator

```bash
mysql -u database_admin_369 -p
```

Enter the password:

```text
DbAdmin@369!
```

### Step 7: Display Existing Databases

```sql
SHOW DATABASES;
```

### Step 8: Select the Expense_Tracker Database

```sql
USE Expense_Tracker;
```

Expected output:

```text
Database changed
```

---

# Task 8: Create Tables and Populate Expense Data

We will create an expenses table and insert five different expense categories:

1. Breakfast
2. Movies
3. Lunch
4. Dinner
5. Snacks

### Step 1: Create the Expenses Table

Execute inside the MySQL shell:

```sql
CREATE TABLE expenses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    expense_category VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    description VARCHAR(255),
    expense_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### Step 2: Verify Table Creation

```sql
SHOW TABLES;
```

### Step 3: Check Table Structure

```sql
DESCRIBE expenses;
```

### Step 4: Insert Expense Records

```sql
INSERT INTO expenses
(expense_category, amount, description, expense_date)
VALUES
('Breakfast', 100.00, 'Morning breakfast', '2026-11-18'),
('Movies', 250.00, 'Movie ticket', '2026-11-18'),
('Lunch', 150.00, 'Afternoon lunch', '2026-11-18'),
('Dinner', 200.00, 'Evening dinner', '2026-11-18'),
('Snacks', 80.00, 'Evening snacks', '2026-11-18');
```

### Step 5: Verify Inserted Records

```sql
SELECT * FROM expenses;
```

Expected sample data:

| ID | Expense Category | Amount |
|---|---|---:|
| 1 | Breakfast | 100.00 |
| 2 | Movies | 250.00 |
| 3 | Lunch | 150.00 |
| 4 | Dinner | 200.00 |
| 5 | Snacks | 80.00 |

### Step 6: Calculate Total Expenses

```sql
SELECT SUM(amount) AS total_expenses
FROM expenses;
```

Expected output:

```text
780.00
```

---

# Additional SQL Practice

### 1. Display Breakfast Expenses

```sql
SELECT *
FROM expenses
WHERE expense_category = 'Breakfast';
```

### 2. Display Expenses Greater Than 100

```sql
SELECT *
FROM expenses
WHERE amount > 100;
```

### 3. Calculate Total Expenses by Category

```sql
SELECT expense_category,
       SUM(amount) AS total_amount
FROM expenses
GROUP BY expense_category;
```

### 4. Display the Highest Expense

```sql
SELECT *
FROM expenses
ORDER BY amount DESC
LIMIT 1;
```

### 5. Display All Expenses in Descending Order

```sql
SELECT *
FROM expenses
ORDER BY amount DESC;
```

---

# Final Project Verification

Execute the following commands to verify the entire environment.

### Linux User Verification

```bash
id senior_devops_engineer_369
```

### Sudo Privileges Verification

```bash
sudo -l -U senior_devops_engineer_369
```

### SSH Authentication Verification

```bash
sudo sshd -T | grep -E 'passwordauthentication|pubkeyauthentication|authenticationmethods'
```

### MySQL Package Verification

```bash
rpm -qa | grep mysql-community
```

### MySQL Service Verification

```bash
sudo systemctl status mysqld
```

### MySQL Database Verification

```bash
mysql -u database_admin_369 -p
```

Inside MySQL:

```sql
SHOW DATABASES;

USE Expense_Tracker;

SHOW TABLES;

SELECT * FROM expenses;

SELECT SUM(amount) FROM expenses;
```

---

# Important Security Considerations

1. Use a strong password for the MySQL root account.
2. Restrict SSH access to trusted IP addresses.
3. Password-only SSH authentication is less secure than SSH key authentication.
4. Never expose MySQL port 3306 publicly.
5. Restrict MySQL privileges to the databases that the administrator needs to manage.
6. Use secure password storage and avoid committing passwords to GitHub.
7. Use appropriate backups before performing database administration tasks.

---

# Project Outcome

After completing this project, the following environment will be available:

| Component | Status |
|---|---|
| AWS EC2 Instance | Configured |
| Amazon Linux 2023 | Installed |
| Linux User | Created |
| SSH Password Authentication | Configured |
| Passwordless Sudo | Configured |
| MySQL Community Repository | Configured |
| MySQL Community Server | Installed |
| MySQL Service | Started and Enabled |
| Database Administrator | Created |
| Expense_Tracker Database | Created |
| Expenses Table | Created |
| Sample Expense Records | Inserted |

---

# Skills Demonstrated

- AWS EC2 Instance Provisioning
- Amazon Linux 2023 Administration
- Linux User and Password Management
- SSH Authentication Configuration
- Sudoers File Management
- Passwordless Sudo Configuration
- DNF Package Management
- Third-Party Repository Configuration
- MySQL Community Server Installation
- Linux systemd Service Management
- MySQL User and Privilege Management
- Database Creation
- SQL Table Management
- SQL Data Insertion and Retrieval
- Basic Database Administration

**Project:** AWS EC2 MySQL Database Server Setup

**Platform:** AWS

**Operating System:** Amazon Linux 2023

**Database:** MySQL Community Server 8.0
