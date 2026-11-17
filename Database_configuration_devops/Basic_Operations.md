# MySQL – Hands-on for Cloud & DevOps Engineers

## Overview

This module covers MySQL database fundamentals and practical SQL operations required for Cloud and DevOps Engineers.

The objective is to understand how to install, configure, manage, troubleshoot, back up, and restore MySQL databases in real-world cloud environments.

**Environment:**
- Cloud Provider: AWS
- Compute: Amazon EC2
- Operating System: Amazon Linux 2023
- Database: MySQL 8.0.x
- Database Port: 3306

---

## 1. Connect to MySQL

Connect to the MySQL server using the root account.

```bash
mysql -u root -p
```

### Basic information commands

```sql
-- Check MySQL version
SELECT VERSION();

-- Check current user
SELECT USER();

-- Display available databases
SHOW DATABASES;

-- Display current date and time
SELECT NOW();

-- Check active connections
SHOW PROCESSLIST;
```

---

## 2. Database Operations (DDL)

DDL stands for Data Definition Language.

These commands are used to create, modify, and delete database structures.

### Create database

```sql
CREATE DATABASE expense;
```

### Display databases

```sql
SHOW DATABASES;
```

### Select database

```sql
USE expense;
```

### Check selected database

```sql
SELECT DATABASE();
```

### Delete database

```sql
DROP DATABASE expense;
```

**Important:** DROP DATABASE permanently deletes the database and its tables.

---

## 3. Table Operations

A database contains tables, and tables contain rows and columns.

### Create a table

```sql
CREATE TABLE employees (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    role VARCHAR(100),
    salary INT
);
```

### Display tables

```sql
SHOW TABLES;
```

### Describe table structure

```sql
DESCRIBE employees;
```

### Delete table

```sql
DROP TABLE employees;
```

---

## 4. Data Operations (DML)

DML stands for Data Manipulation Language.

These commands are used to insert, retrieve, update, and delete records.

### Insert a record

```sql
INSERT INTO employees (name, role, salary)
VALUES ('Pradeep', 'DevOps Engineer', 1200000);
```

### Insert multiple records

```sql
INSERT INTO employees (name, role, salary)
VALUES
('Ravi', 'Cloud Engineer', 1000000),
('Kiran', 'Linux Engineer', 900000),
('Arun', 'SRE Engineer', 1500000);
```

### Retrieve all records

```sql
SELECT * FROM employees;
```

### Retrieve specific columns

```sql
SELECT name, role FROM employees;
```

### Update records

```sql
UPDATE employees
SET salary = 1400000
WHERE name = 'Pradeep';
```

### Delete records

```sql
DELETE FROM employees
WHERE name = 'Arun';
```

**Important:** Always verify the WHERE condition before executing UPDATE or DELETE.

---

## 5. Filtering and Sorting

### WHERE – Filter records

```sql
SELECT * FROM employees
WHERE salary > 1000000;
```

### ORDER BY – Sort records

```sql
SELECT * FROM employees
ORDER BY salary DESC;
```

### LIMIT – Restrict results

```sql
SELECT * FROM employees
LIMIT 2;
```

### COUNT – Count records

```sql
SELECT COUNT(*) FROM employees;
```

### DISTINCT – Retrieve unique values

```sql
SELECT DISTINCT role FROM employees;
```

---

## 6. Database User Management

In production environments, applications should use dedicated database accounts instead of the MySQL root account.

### Create application user

```sql
CREATE USER 'expenseuser'@'localhost'
IDENTIFIED BY 'StrongPassword123!';
```

### Grant database permissions

```sql
GRANT ALL PRIVILEGES ON expense.*
TO 'expenseuser'@'localhost';
```

### Check user permissions

```sql
SHOW GRANTS FOR 'expenseuser'@'localhost';
```

### Revoke permissions

```sql
REVOKE ALL PRIVILEGES ON expense.*
FROM 'expenseuser'@'localhost';
```

### Delete database user

```sql
DROP USER 'expenseuser'@'localhost';
```

**Production practice:** Follow the principle of least privilege and grant only the permissions required by the application.

---

## 7. Database Troubleshooting

Useful commands for database troubleshooting and production support.

### Check database tables

```sql
SHOW TABLES;
```

### Check table structure

```sql
DESCRIBE employees;
```

### Check active connections

```sql
SHOW PROCESSLIST;
```

### Check database size

```sql
SELECT
    table_schema AS database_name,
    ROUND(
        SUM(data_length + index_length) / 1024 / 1024, 2
    ) AS size_mb
FROM information_schema.tables
GROUP BY table_schema;
```

### Check table status

```sql
SHOW TABLE STATUS;
```

---

## 8. MySQL Service Management (Linux)

Manage the MySQL service using systemctl.

| Operation | Command |
|---|---|
| Start MySQL | `systemctl start mysqld` |
| Stop MySQL | `systemctl stop mysqld` |
| Restart MySQL | `systemctl restart mysqld` |
| Enable at boot | `systemctl enable mysqld` |
| Check status | `systemctl status mysqld` |
| Check logs | `journalctl -u mysqld` |
| Check version | `mysql --version` |
| Check port | `ss -lntp \| grep 3306` |

---

## 9. Database Backup and Restore

Backup and recovery are important responsibilities in production database operations.

### Backup database

Execute from the Linux terminal:

```bash
mysqldump -u root -p expense > expense_backup.sql
```

### Verify backup file

```bash
ls -lh expense_backup.sql
```

### Restore database

```bash
mysql -u root -p expense < expense_backup.sql
```

**Important:** Always test database restoration. A backup is useful only when it can be successfully restored.

---

## 10. MySQL Operations – DevOps Perspective

As a Cloud and DevOps Engineer, understand the following responsibilities:

- Install and configure MySQL on cloud instances.
- Manage MySQL services using systemctl.
- Create databases and application database users.
- Configure database access and permissions.
- Understand database ports and network connectivity.
- Troubleshoot database connection failures.
- Monitor database connections and resource usage.
- Perform database backups and restoration.
- Secure database credentials.
- Integrate MySQL with application deployments.

---

## 11. Hands-on Learning Roadmap

| Task | Topic | Status |
|---|---|---|
| 01 | Connect to MySQL and explore | Pending |
| 02 | Create databases and tables | Pending |
| 03 | Insert and retrieve records | Pending |
| 04 | Update and delete records | Pending |
| 05 | Database user management | Pending |
| 06 | Database troubleshooting | Pending |
| 07 | Database backup and restore | Pending |
| 08 | Connect ExpenseApp to MySQL | Pending |
| 09 | Production database operations | Pending |

---

## Learning Outcome

After completing these hands-on exercises, you should be able to:

1. Understand basic MySQL architecture and SQL operations.
2. Manage databases, tables, records, and users.
3. Perform common database troubleshooting.
4. Manage MySQL services on Linux servers.
5. Perform database backup and restoration.
6. Configure database connectivity for cloud-hosted applications.

**Next Goal:** Integrate MySQL with the ExpenseApp application deployed on AWS EC2 and understand database connectivity from a DevOps Engineer's perspective.