# Production Troubleshooting – Cloud & DevOps Engineering

## 1. Introduction

Production troubleshooting is one of the most important responsibilities of a Senior Cloud / DevOps Engineer.

When an application stops working, users may experience:

- Website not loading.
- HTTP 500 Internal Server Error.
- HTTP 502 Bad Gateway.
- HTTP 503 Service Unavailable.
- HTTP 504 Gateway Timeout.
- Slow API responses.
- Database connection failures.
- High CPU and memory utilization.
- Application crashes.
- Failed health checks.

A Senior DevOps Engineer must identify the failing component, investigate logs and metrics, restore service and prevent the issue from happening again.

## 2. Production Application Architecture

Let's consider a real-world AWS single-tier application deployment.

### Architecture Diagram

```text
                    INTERNET
                        |
                        |
                   ROUTE 53
                        |
                        |
                 AWS APPLICATION
                   LOAD BALANCER
                        |
                        |
                  TARGET GROUP
                        |
                        |
                  EC2 INSTANCE
                        |
                        |
                  NGINX SERVER
                     Port 80
                        |
                        |
                 BACKEND APPLICATION
                     Port 8080
                        |
                        |
                   MYSQL DATABASE
                     Port 3306
```

### Component Responsibilities

| Component | Responsibility |
|---|---|
| Route 53 | DNS resolution |
| ALB | Distributes incoming traffic |
| Target Group | Registers and monitors backend targets |
| EC2 | Hosts the application |
| Nginx | Reverse proxy and web server |
| Application | Processes business logic and API requests |
| MySQL | Stores application data |

### Important Ports

| Service | Port |
|---|---|
| HTTP | 80 |
| HTTPS | 443 |
| SSH | 22 |
| Nginx | 80 / 443 |
| Spring Boot | 8080 |
| MySQL | 3306 |

## 3. Production Troubleshooting Methodology

Never randomly restart services in production.

Follow this systematic troubleshooting approach.

```text
            USER REPORTS ISSUE
                    |
                    v
            IDENTIFY THE SYMPTOM
                    |
                    v
             CHECK HTTP STATUS
                    |
                    v
             CHECK AWS ALB
                    |
                    v
               CHECK EC2
                    |
                    v
             CHECK NGINX
                    |
                    v
          CHECK APPLICATION LOGS
                    |
                    v
            CHECK DATABASE
                    |
                    v
            IDENTIFY ROOT CAUSE
                    |
                    v
             APPLY RESOLUTION
                    |
                    v
             VERIFY APPLICATION
                    |
                    v
          DOCUMENT THE INCIDENT
```

### Step 1: Understand the issue

Ask:

1. Is the entire website down?
2. Is only one API failing?
3. Is the application responding slowly?
4. Is the issue affecting all users or specific users?
5. When did the issue start?
6. Was there a recent deployment or configuration change?

### Step 2: Check HTTP response

```bash
curl -I https://example.com
```

Get detailed request information:

```bash
curl -v https://example.com
```

Check the response code:

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
```

Common responses:

| Code | Meaning | Investigation |
|---|---|---|
| 200 | Successful | Verify application behavior |
| 301 | Permanent redirect | Check redirect configuration |
| 302 | Temporary redirect | Check redirect destination |
| 400 | Bad request | Check request payload |
| 401 | Unauthorized | Check authentication |
| 403 | Forbidden | Check permissions |
| 404 | Not found | Check URL and routes |
| 429 | Too many requests | Check rate limits |
| 500 | Internal server error | Check application logs |
| 502 | Bad gateway | Check upstream application |
| 503 | Service unavailable | Check service and target health |
| 504 | Gateway timeout | Check application and database latency |

---

# 4. Nginx Troubleshooting

## 4.1 Check Nginx Service Status

```bash
sudo systemctl status nginx
```

Check whether Nginx is running.

Expected:

```text
Active: active (running)
```

If Nginx is stopped:

```bash
sudo systemctl start nginx
```

Enable automatic startup:

```bash
sudo systemctl enable nginx
```

## 4.2 Check Nginx Configuration

```bash
sudo nginx -t
```

Expected:

```text
syntax is ok
test is successful
```

If configuration contains an error, Nginx may fail to reload or start.

## 4.3 Check Nginx Logs

Access logs:

```bash
sudo tail -f /var/log/nginx/access.log
```

Error logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

Check recent errors:

```bash
sudo tail -n 100 /var/log/nginx/error.log
```

## 4.4 Check Nginx Listening Port

```bash
sudo ss -tulnp | grep nginx
```

Check port 80:

```bash
sudo ss -tulnp | grep ':80'
```

## 4.5 Common Nginx Production Issues

| Issue | Possible Cause | Resolution |
|---|---|---|
| Nginx not starting | Configuration error | Run `nginx -t` |
| HTTP 502 | Backend unavailable | Check application |
| HTTP 504 | Upstream timeout | Investigate application latency |
| HTTP 403 | Permission denied | Check file permissions and access rules |
| HTTP 404 | Incorrect route | Check location and proxy rules |
| Port 80 unavailable | Port conflict | Identify process using port 80 |

## 4.6 Nginx Reverse Proxy Example

Example configuration:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Validate:

```bash
sudo nginx -t
```

Reload:

```bash
sudo systemctl reload nginx
```

---

# 5. AWS EC2 Troubleshooting

## 5.1 Check EC2 Instance Status

From the AWS Console:

1. Open EC2.
2. Select Instances.
3. Check Instance State.
4. Check Status Checks.

Important EC2 status checks:

- System status check.
- Instance status check.
- Attached EBS status check.

A failed system status check may indicate an issue with the underlying AWS infrastructure.

A failed instance status check may indicate an operating system or instance-level problem.

## 5.2 Check CPU Utilization

Linux command:

```bash
top
```

Alternative:

```bash
uptime
```

Check CPU information:

```bash
mpstat -P ALL 1
```

If `mpstat` is unavailable, install the appropriate sysstat package.

AWS CloudWatch:

- CPUUtilization
- NetworkIn
- NetworkOut
- StatusCheckFailed

## 5.3 Check Memory Utilization

```bash
free -h
```

Check processes:

```bash
ps aux --sort=-%mem | head
```

Identify memory-consuming processes.

## 5.4 Check Disk Utilization

```bash
df -h
```

Check inode usage:

```bash
df -i
```

Find large directories:

```bash
sudo du -sh /var/* 2>/dev/null
```

Find large files:

```bash
sudo find /var/log -type f -size +100M -ls
```

Common production issue:

The root EBS volume becomes 100% full because application logs are continuously generated.

Possible consequences:

- Application cannot write logs.
- Database writes may fail.
- Services may stop functioning.
- Deployment may fail.

Resolution:

Identify large files, rotate or archive logs, and expand EBS capacity if required.

Do not delete active logs blindly.

## 5.5 Check Network Connectivity

Check listening ports:

```bash
sudo ss -tulnp
```

Test the application locally:

```bash
curl -v http://localhost:8080
```

Test MySQL connectivity:

```bash
nc -zv MYSQL_PRIVATE_IP 3306
```

Check:

- EC2 security groups.
- Network ACLs.
- Route tables.
- VPC connectivity.
- DNS resolution.
- Application bind address.

## 5.6 Check System Logs

```bash
sudo journalctl -xe
```

Check previous boot logs:

```bash
sudo journalctl -b -1
```

Check kernel messages:

```bash
sudo dmesg -T | tail -n 50
```

---

# 6. AWS Application Load Balancer Troubleshooting

## 6.1 Understand ALB Request Flow

```text
               CLIENT
                  |
                  v
            APPLICATION LB
                  |
                  v
             LISTENER :443
                  |
                  v
              LISTENER RULE
                  |
                  v
              TARGET GROUP
                  |
                  v
             EC2 INSTANCE
                  |
                  v
               NGINX
                  |
                  v
             APPLICATION
```

## 6.2 Check Target Group Health

AWS Console:

1. Open EC2.
2. Select Target Groups.
3. Open the application target group.
4. Select Targets.
5. Review target health.

Possible target health states:

| State | Meaning |
|---|---|
| Healthy | Target passes health checks |
| Initial | Health check registration in progress |
| Unhealthy | Target failed health checks |
| Draining | Target is deregistering |
| Unused | Target is not currently in use |

## 6.3 Common ALB Health Check Problems

| Problem | Possible Cause |
|---|---|
| Health check timeout | Application is slow or unreachable |
| Health check failed | Wrong health check path |
| Connection refused | Application is not listening |
| 404 health check | Incorrect endpoint |
| 403 health check | Access restrictions |
| Target unhealthy | Port or security group mismatch |

Example health check:

```text
Protocol: HTTP
Port: Traffic port
Path: /health
Success Codes: 200
Interval: 30 seconds
Timeout: 5 seconds
Healthy Threshold: 3
Unhealthy Threshold: 2
```

These are example settings, not universal production defaults.

## 6.4 Check ALB Security Groups

Example:

```text
ALB Security Group
       |
       | Inbound HTTPS 443
       v
     INTERNET

ALB Security Group
       |
       | Outbound application port 80
       v
EC2 Security Group
       |
       | Inbound port 80
       | Source: ALB Security Group
       v
    EC2 INSTANCE
```

Best practice:

Allow application traffic from the ALB security group rather than opening the backend application port to the entire internet.

## 6.5 Troubleshooting ALB HTTP 503

Possible causes:

- No registered targets.
- No healthy targets.
- Listener rule issues.
- Target registration problems.
- Application capacity problems.

Investigation:

1. Check listener rules.
2. Check target registration.
3. Check target health.
4. Check EC2 application status.
5. Check security groups.
6. Review ALB access logs and CloudWatch metrics.

## 6.6 Troubleshooting ALB HTTP 504

Possible causes:

- Application response is slow.
- Database queries take too long.
- Backend dependency is unavailable.
- Connection or idle timeout is reached.

Investigate application latency before increasing timeout values.

---

# 7. Application Troubleshooting

## 7.1 Check Application Service

For a Spring Boot application running as a systemd service:

```bash
sudo systemctl status myapp
```

Start:

```bash
sudo systemctl start myapp
```

Restart, when appropriate:

```bash
sudo systemctl restart myapp
```

Enable automatic startup:

```bash
sudo systemctl enable myapp
```

## 7.2 Check Application Logs

```bash
sudo journalctl -u myapp -f
```

Last 100 lines:

```bash
sudo journalctl -u myapp -n 100 --no-pager
```

Logs from the last 30 minutes:

```bash
sudo journalctl -u myapp --since "30 minutes ago"
```

## 7.3 Check Application Port

```bash
sudo ss -tulnp | grep 8080
```

Test locally:

```bash
curl -i http://localhost:8080/health
```

## 7.4 Common Application Issues

| Issue | Possible Cause |
|---|---|
| Application stopped | Process crashed |
| HTTP 500 | Unhandled application exception |
| HTTP 502 | Backend unavailable |
| HTTP 503 | Application overloaded |
| HTTP 504 | Slow API or downstream dependency |
| High memory | Memory leak or excessive workload |
| Slow response | Database or external API latency |

## 7.5 Java Application Troubleshooting

Check Java process:

```bash
ps -ef | grep java
```

Check Java version:

```bash
java -version
```

Check process resource usage:

```bash
top -p JAVA_PID
```

Replace `JAVA_PID` with the actual process ID.

For Java memory and garbage collection issues, investigate:

- Heap utilization.
- Garbage collection logs.
- OutOfMemoryError.
- Thread dumps.
- Application response time.

---

# 8. MySQL Database Troubleshooting

## 8.1 Check MySQL Service

```bash
sudo systemctl status mysqld
```

Start:

```bash
sudo systemctl start mysqld
```

Enable:

```bash
sudo systemctl enable mysqld
```

## 8.2 Connect to MySQL

```bash
mysql -u root -p
```

Check databases:

```sql
SHOW DATABASES;
```

Select database:

```sql
USE EXPENSES;
```

Show tables:

```sql
SHOW TABLES;
```

Check table structure:

```sql
DESCRIBE table_name;
```

## 8.3 Check Active Connections

```sql
SHOW PROCESSLIST;
```

Detailed process list:

```sql
SHOW FULL PROCESSLIST;
```

Check maximum connections:

```sql
SHOW VARIABLES LIKE 'max_connections';
```

Check current connections:

```sql
SHOW STATUS LIKE 'Threads_connected';
```

## 8.4 Check Slow Queries

```sql
SHOW VARIABLES LIKE 'slow_query_log';
```

Check slow query log location:

```sql
SHOW VARIABLES LIKE 'slow_query_log_file';
```

Slow query logs help identify queries that affect application performance.

## 8.5 Test Database Connectivity

From the application EC2 instance:

```bash
nc -zv MYSQL_PRIVATE_IP 3306
```

Connect using the MySQL client:

```bash
mysql -h MYSQL_PRIVATE_IP -u appuser -p
```

Check:

- Database service status.
- Security group rules.
- Database credentials.
- Database connection limits.
- Disk capacity.
- Slow queries.
- Network connectivity.

Never expose MySQL port 3306 publicly.

---

# 9. Real-Time Production Troubleshooting Scenarios

## Scenario 1: Website Returns HTTP 502

### Problem

Users report that the website is unavailable.

Browser shows:

```text
502 Bad Gateway
```

### Architecture

```text
CLIENT
   |
   v
NGINX
   |
   v
SPRING BOOT :8080
   |
   X
APPLICATION DOWN
```

### Investigation

Step 1: Check Nginx.

```bash
sudo systemctl status nginx
```

Step 2: Check application.

```bash
sudo systemctl status myapp
```

Step 3: Check port 8080.

```bash
sudo ss -tulnp | grep 8080
```

Step 4: Check application logs.

```bash
sudo journalctl -u myapp -n 100
```

Step 5: Test backend.

```bash
curl -v http://localhost:8080/health
```

### Root Cause

The Spring Boot application crashed due to an application configuration issue.

### Resolution

After identifying and correcting the configuration problem:

```bash
sudo systemctl restart myapp
```

Verify:

```bash
curl -i http://localhost:8080/health
```

Then verify the external application endpoint.

### Prevention

- Configure systemd restart policies.
- Implement application monitoring.
- Configure ALB health checks.
- Send application logs to a centralized logging system.
- Alert on unhealthy targets.

---

## Scenario 2: Application Returns HTTP 503

### Problem

Users receive:

```text
503 Service Unavailable
```

### Investigation

1. Open AWS EC2 Target Groups.
2. Check target health.
3. Verify whether targets are registered.
4. Check application service status.
5. Check CPU and memory.
6. Check Auto Scaling activity.

### Possible Root Cause

All application instances are unhealthy because the health check endpoint is failing.

### Resolution

Identify why the health endpoint is failing and restore application health.

Verify:

```bash
curl -i http://localhost:8080/health
```

Do not change health check success codes to hide a genuine application failure.

---

## Scenario 3: Application Returns HTTP 504

### Problem

The application takes too long to respond.

### Investigation

Check application logs:

```bash
sudo journalctl -u myapp -f
```

Check MySQL:

```sql
SHOW FULL PROCESSLIST;
```

Check system resources:

```bash
top
```

Check disk:

```bash
df -h
```

### Possible Root Cause

A slow database query is delaying the API response.

### Resolution

Identify the slow query, review its execution plan, optimize indexes or query logic, and verify the application response time.

Review timeout configuration only after understanding the latency.

---

## Scenario 4: EC2 Disk Usage Reaches 100%

### Problem

Application deployment fails and the application cannot write log files.

### Investigation

```bash
df -h
```

Find large directories:

```bash
sudo du -xhd1 /var 2>/dev/null
```

Find large log files:

```bash
sudo find /var/log -type f -size +100M -ls
```

### Possible Root Cause

Application logs have consumed the available root EBS volume space.

### Resolution

- Identify the files consuming space.
- Configure log rotation.
- Archive or safely remove obsolete logs.
- Expand EBS capacity if necessary.
- Verify filesystem utilization.

### Prevention

Implement disk utilization alerts and log rotation policies.

---

## Scenario 5: Application Cannot Connect to MySQL

### Problem

Application logs show:

```text
Communications link failure
```

### Investigation

Check MySQL:

```bash
sudo systemctl status mysqld
```

Check listening port:

```bash
sudo ss -tulnp | grep 3306
```

Check network connectivity:

```bash
nc -zv MYSQL_PRIVATE_IP 3306
```

Check MySQL connections:

```sql
SHOW PROCESSLIST;
```

### Possible Root Cause

- MySQL service stopped.
- Incorrect database endpoint.
- Security group does not allow port 3306.
- Database connection limit reached.
- Incorrect credentials.

### Resolution

Identify the actual failure, restore connectivity or correct database configuration, and verify that the application can establish a database connection.

---

## Scenario 6: Application CPU Utilization Reaches 95%

### Problem

The application becomes slow during peak traffic.

### Investigation

```bash
top
```

```bash
uptime
```

```bash
ps aux --sort=-%cpu | head
```

Check AWS CloudWatch CPUUtilization.

### Possible Root Cause

An application process is consuming excessive CPU because of high traffic, inefficient code or excessive processing.

### Resolution

- Identify the process.
- Investigate application logs and thread activity.
- Review request volume.
- Identify expensive operations.
- Scale capacity if necessary.
- Optimize application performance.

Do not terminate production processes without understanding their role and impact.

---

# 10. Production Incident Response Checklist

When a production incident occurs, follow this checklist.

## Initial Investigation

- [ ] Identify the affected application.
- [ ] Identify the start time.
- [ ] Check HTTP response code.
- [ ] Identify affected users and APIs.
- [ ] Check recent deployments or changes.
- [ ] Check whether the issue is ongoing.

## Infrastructure Investigation

- [ ] Check AWS EC2 instance health.
- [ ] Check CPU utilization.
- [ ] Check memory utilization.
- [ ] Check disk utilization.
- [ ] Check network connectivity.
- [ ] Check security groups.

## Application Investigation

- [ ] Check Nginx service.
- [ ] Check Nginx error logs.
- [ ] Check application service.
- [ ] Check application logs.
- [ ] Check application ports.
- [ ] Test health endpoints.

## Database Investigation

- [ ] Check MySQL service.
- [ ] Check database connectivity.
- [ ] Check active connections.
- [ ] Check slow queries.
- [ ] Check disk utilization.
- [ ] Check database errors.

## Recovery and Prevention

- [ ] Identify the root cause.
- [ ] Restore application availability.
- [ ] Verify API responses.
- [ ] Verify database operations.
- [ ] Monitor application after recovery.
- [ ] Document the incident.
- [ ] Create preventive actions.

---

# 11. Important Production Troubleshooting Commands

| Purpose | Command |
|---|---|
| Check Nginx | `systemctl status nginx` |
| Check application | `systemctl status myapp` |
| Check MySQL | `systemctl status mysqld` |
| Check CPU | `top` |
| Check memory | `free -h` |
| Check disk | `df -h` |
| Check inodes | `df -i` |
| Check ports | `ss -tulnp` |
| Check Nginx logs | `tail -f /var/log/nginx/error.log` |
| Check application logs | `journalctl -u myapp -f` |
| Check MySQL connections | `SHOW PROCESSLIST;` |
| Test API | `curl -v URL` |
| Test TCP connectivity | `nc -zv HOST PORT` |

---

# 12. Senior Cloud / DevOps Engineer Interview Questions

### Q1. A production website is returning HTTP 502. How would you troubleshoot it?

**Answer:**

First, I would identify whether the 502 is generated by Nginx or the AWS Application Load Balancer.

Then I would check:

1. ALB target health.
2. EC2 instance status.
3. Nginx service status.
4. Nginx error logs.
5. Backend application service.
6. Application listening port.
7. Network and security group configuration.

Finally, I would test the backend directly and identify the root cause.

### Q2. All ALB targets are unhealthy. What would you check?

**Answer:**

I would verify application availability, health check path, protocol, port, expected status code, security groups, network connectivity and application startup status.

### Q3. How do you troubleshoot high CPU utilization on EC2?

**Answer:**

I would use `top`, `ps`, `uptime` and CloudWatch metrics to identify the resource-consuming process. Then I would correlate the issue with application logs, traffic patterns and recent deployments.

### Q4. How do you troubleshoot an application that is running but not responding?

**Answer:**

I would verify the application port, inspect logs, check thread and memory utilization, test the API locally, and investigate downstream dependencies such as MySQL.

### Q5. How do you troubleshoot database connectivity issues?

**Answer:**

I would check the database service, endpoint, port, security groups, credentials, network connectivity and connection limits.

### Q6. What is your approach to production incident management?

**Answer:**

My approach is:

1. Detect and acknowledge the incident.
2. Assess business impact.
3. Investigate infrastructure and application health.
4. Identify the failing component.
5. Restore service safely.
6. Validate recovery.
7. Perform root cause analysis.
8. Implement preventive actions.

### Q7. Would you immediately restart an application when it returns HTTP 500?

**Answer:**

No. I would first inspect application logs, identify the exception and determine whether the issue is related to application logic, database connectivity, configuration or resource exhaustion.

Restarting without identifying the root cause may temporarily hide the problem.

---

# 13. Monitoring and Observability

A production environment should not depend only on manual troubleshooting.

Important monitoring tools:

| Tool | Purpose |
|---|---|
| AWS CloudWatch | AWS infrastructure metrics and alarms |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboards |
| ELK Stack | Centralized log analysis |
| AWS CloudTrail | AWS API activity auditing |
| AWS ALB Access Logs | Load balancer request analysis |

### Important Metrics to Monitor

**EC2:**
- CPU utilization.
- Network traffic.
- Disk utilization through an appropriate agent or exporter.
- Memory utilization through an appropriate agent or exporter.

**ALB:**
- HealthyHostCount.
- UnHealthyHostCount.
- HTTPCode_ELB_5XX_Count.
- HTTPCode_Target_5XX_Count.
- TargetResponseTime.

**Application:**
- API response time.
- Error rate.
- Request rate.
- JVM heap utilization.
- Thread count.

**MySQL:**
- Active connections.
- Slow queries.
- Query latency.
- Disk utilization.
- Database availability.

---

# 14. Production Troubleshooting – Final Takeaways

A Senior Cloud / DevOps Engineer should understand the complete application request flow:

```text
USER
 |
 v
ROUTE 53
 |
 v
AWS ALB
 |
 v
EC2
 |
 v
NGINX
 |
 v
APPLICATION
 |
 v
MYSQL
```

When an issue occurs:

- Start with the user-facing symptom.
- Identify the failing layer.
- Check logs, metrics and connectivity.
- Find the actual root cause.
- Restore service safely.
- Validate the recovery.
- Document the incident.
- Implement preventive monitoring and automation.

## Learning Objective

By completing this module, you should be able to:

1. Troubleshoot HTTP 4xx and 5xx errors.
2. Diagnose Nginx reverse proxy issues.
3. Troubleshoot AWS EC2 instances.
4. Investigate ALB target health problems.
5. Diagnose application failures.
6. Troubleshoot MySQL connectivity and performance.
7. Perform production incident response.
8. Explain troubleshooting scenarios confidently in Senior Cloud / DevOps Engineer interviews.

**Next Step:** Perform these troubleshooting exercises on your own AWS EC2 lab environment and document the findings in GitHub.