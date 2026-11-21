# HTTP 5xx – Server Error Status Codes

## 1. What are HTTP 5xx Status Codes?

HTTP 5xx status codes indicate that a server failed to fulfill an apparently valid request because of a server-side problem.

As a Senior Cloud / DevOps Engineer, 5xx troubleshooting is particularly important in production environments.

Common components involved:

- AWS Application Load Balancer.
- EC2 instances.
- Nginx and Apache.
- Java / Spring Boot applications.
- MySQL databases.
- Microservices.
- Kubernetes workloads.

## 2. Understanding HTTP 5xx Codes

| Code | Meaning | Real-Time Scenario |
|---|---|---|
| 500 | Internal Server Error | Application exception |
| 502 | Bad Gateway | Nginx cannot get a valid upstream response |
| 503 | Service Unavailable | Application overloaded or unavailable |
| 504 | Gateway Timeout | Upstream service takes too long |

---

## 3. HTTP 500 – Internal Server Error

### Explanation

HTTP 500 indicates that the server encountered an unexpected condition and could not complete the request.

### Visual Example

```text
CLIENT
   |
   | GET /api/orders
   v
NGINX
   |
   v
APPLICATION SERVER
   |
   | Execute business logic
   |
   | Unexpected exception
   v
HTTP 500
   |
   v
CLIENT
```

### API Example

Response:

```http
HTTP/1.1 500 Internal Server Error
Content-Type: application/json
```

```json
{
  "error": "Internal server error"
}
```

### Practical Example

```bash
curl -i http://localhost:8080/api/orders
```

### Real-Time Scenario

A Spring Boot application attempts to retrieve order information.

A Java exception occurs because of an unexpected null value or an unhandled database error.

The application returns HTTP 500.

### DevOps Troubleshooting

Check application logs:

```bash
sudo journalctl -u myapp -n 100 --no-pager
```

Check service:

```bash
sudo systemctl status myapp
```

Check CPU and memory:

```bash
top
free -h
```

**DevOps takeaway:** Investigate application exceptions, database failures, resource exhaustion and configuration issues.

---

## 4. HTTP 502 – Bad Gateway

### Explanation

HTTP 502 indicates that a gateway or proxy received an invalid response from an upstream server.

Commonly seen when Nginx communicates with an application running on another port.

### Visual Example

```text
CLIENT
   |
   v
NGINX SERVER
   |
   | Forward request
   v
APPLICATION SERVER
   |
   | Connection refused
   | Invalid response
   v
NGINX
   |
   | HTTP 502
   v
CLIENT
```

### API Example

```http
HTTP/1.1 502 Bad Gateway
```

### Nginx Configuration Example

```nginx
server {
    listen 80;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

### Practical Example

Check whether the backend application is listening:

```bash
sudo ss -tulnp | grep 8080
```

Test the backend directly:

```bash
curl -i http://127.0.0.1:8080
```

Check Nginx logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

### Real-Time Scenario

A Spring Boot application crashes on an EC2 instance.

Nginx is still running but cannot connect to the application on port 8080.

Users receive HTTP 502.

### AWS Troubleshooting

Check:

- EC2 application health.
- Nginx upstream configuration.
- Security group rules.
- Application listening port.
- ALB target health.
- Backend connection errors.

**DevOps takeaway:** A 502 often indicates an upstream communication problem, not necessarily an Nginx failure.

---

## 5. HTTP 503 – Service Unavailable

### Explanation

HTTP 503 indicates that the server is currently unable to handle the request.

This may happen because of maintenance, overload or temporary service unavailability.

### Visual Example

```text
CLIENT
   |
   v
AWS LOAD BALANCER
   |
   | Forward traffic
   v
TARGET GROUP
   |
   | No healthy targets
   v
HTTP 503
   |
   v
CLIENT
```

### API Example

```http
HTTP/1.1 503 Service Unavailable
Retry-After: 60
```

```json
{
  "error": "Service temporarily unavailable"
}
```

### Practical Example

```bash
curl -i http://localhost:8080/health
```

Check application service:

```bash
sudo systemctl status myapp
```

### Real-Time Scenario

During a traffic spike, all EC2 application instances become unhealthy.

The AWS Application Load Balancer has no healthy targets available.

Clients may receive HTTP 503.

### AWS Troubleshooting

1. Check ALB target group health.
2. Check EC2 instance status.
3. Verify health check path and port.
4. Check application service status.
5. Review CPU and memory utilization.
6. Review Auto Scaling activity.
7. Check CloudWatch metrics and logs.

**DevOps takeaway:** Investigate application availability, target health, overload and maintenance conditions.

---

## 6. HTTP 504 – Gateway Timeout

### Explanation

HTTP 504 indicates that a gateway or proxy did not receive a timely response from an upstream server.

### Visual Example

```text
CLIENT
   |
   v
APPLICATION LOAD BALANCER
   |
   v
NGINX
   |
   v
APPLICATION SERVER
   |
   | Waiting for database query
   | Query takes too long
   |
   X
TIMEOUT
   |
   v
HTTP 504
   |
   v
CLIENT
```

### API Example

```http
HTTP/1.1 504 Gateway Timeout
```

```json
{
  "error": "Gateway timeout"
}
```

### Practical Example

```bash
curl -i --max-time 10 http://localhost:8080/api/reports
```

This command limits the client-side wait to 10 seconds. It does not itself configure a server-side timeout.

### Real-Time Scenario

An application generates a large financial report.

The database query takes 90 seconds, but the upstream gateway timeout is configured for 60 seconds.

The client receives HTTP 504.

### DevOps Troubleshooting

Check:

Application logs:

```bash
sudo journalctl -u myapp -n 100
```

Nginx logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

Database connections:

```bash
mysql -u root -p -e "SHOW PROCESSLIST;"
```

Check resource utilization:

```bash
top
free -h
iostat -xz 1
```

Review:

- ALB idle timeout.
- Nginx `proxy_read_timeout`.
- Application request timeout.
- Database query execution time.
- Downstream service latency.

**DevOps takeaway:** Identify which component is timing out. Increasing timeout values without fixing slow operations can hide the real problem.

---

## 7. Comparison Table

| Code | Meaning | Common Cause |
|---|---|---|
| 500 | Internal Server Error | Application exception |
| 502 | Bad Gateway | Invalid upstream response |
| 503 | Service Unavailable | No healthy capacity |
| 504 | Gateway Timeout | Upstream response too slow |

## 8. Senior DevOps Interview Questions

**Q1. Difference between HTTP 500 and 502?**

500 generally indicates an application-side internal error. 502 indicates that a gateway or proxy received an invalid response from an upstream server.

**Q2. What causes HTTP 502 in Nginx?**

Backend application unavailable, incorrect upstream port, connection refused or invalid upstream response.

**Q3. What causes HTTP 503 in AWS ALB?**

One possible cause is that the load balancer has no healthy targets available. Also investigate listener rules, capacity and other service-side conditions.

**Q4. Difference between HTTP 502 and 504?**

502 means the gateway received an invalid upstream response. 504 means it did not receive a timely upstream response.

**Q5. How would you troubleshoot HTTP 504 in production?**

1. Check ALB metrics and access logs.
2. Check Nginx error logs.
3. Check application response time.
4. Check database query performance.
5. Check downstream dependencies.
6. Review timeout configuration.
7. Identify the slowest component.

## 9. Production Troubleshooting Command Checklist

### Nginx

```bash
sudo systemctl status nginx
sudo nginx -t
sudo tail -f /var/log/nginx/error.log
```

### Application

```bash
sudo systemctl status myapp
sudo journalctl -u myapp -f
```

### Linux Resources

```bash
top
free -h
df -h
iostat -xz 1
```

### Network and Ports

```bash
sudo ss -tulnp
curl -v http://localhost:8080/health
```

### MySQL

```bash
mysql -u root -p -e "SHOW PROCESSLIST;"
```

## 10. Key Takeaways

- 500 – Application encountered an unexpected error.
- 502 – Gateway received an invalid upstream response.
- 503 – Service temporarily unavailable.
- 504 – Gateway timed out waiting for upstream.

**Senior DevOps principle:** Do not just restart services when a 5xx error occurs. Identify the failing layer, collect logs and metrics, isolate the root cause, restore service and implement preventive measures.

Next: `05_Production_Troubleshooting.md`
