# HTTP 2xx – Success Status Codes

## 1. What are HTTP 2xx Status Codes?

HTTP 2xx status codes indicate that an HTTP request was successfully received, understood, and processed by the server.

As a Cloud / DevOps Engineer, we use these status codes to verify:

- Application health.
- API availability.
- Successful deployments.
- Database operations.
- Load balancer health checks.
- Communication between microservices.

## 2. Understanding HTTP 2xx Codes

| Status Code | Meaning | Real-Time Scenario |
|---|---|---|
| 200 OK | Request successful | Fetch user details |
| 201 Created | Resource created | Create a new user |
| 202 Accepted | Request accepted for processing | Background job submitted |
| 204 No Content | Request successful, no response body | Delete a user |

---

# 3. HTTP 200 – OK

### What is 200 OK?

HTTP 200 means the server successfully processed the request and returned the requested information.

### Visual Example

```text
       CLIENT
          |
          | GET /api/users/101
          |
          v
    APPLICATION SERVER
          |
          | Process request
          | Retrieve user from database
          |
          v
        DATABASE
          |
          | User details found
          |
          v
    APPLICATION SERVER
          |
          | HTTP 200 OK
          |
          v
       CLIENT
```

### API Example

Request:

```http
GET /api/users/101 HTTP/1.1
Host: api.example.com
```

Response:

```http
HTTP/1.1 200 OK
Content-Type: application/json
```

```json
{
  "id": 101,
  "name": "Pradeep",
  "role": "DevOps Engineer",
  "status": "Active"
}
```

### Real-Time Scenario

A developer accesses an employee management application and requests employee details.

The application retrieves the information from MySQL and returns HTTP 200.

### DevOps Practical Example

Check an application's health endpoint:

```bash
curl -i http://localhost:8080/health
```

Expected response:

```http
HTTP/1.1 200 OK
Content-Type: application/json
```

```json
{
  "status": "UP"
}
```

**DevOps takeaway:** HTTP 200 indicates that the endpoint successfully handled the request. It does not necessarily prove that every application dependency is healthy.

---

# 4. HTTP 201 – Created

### What is 201 Created?

HTTP 201 means the server successfully created a new resource.

It is commonly returned after POST requests.

### Visual Example

```text
       CLIENT
          |
          | POST /api/users
          | Send new user details
          |
          v
    APPLICATION SERVER
          |
          | Validate user details
          |
          v
        DATABASE
          |
          | Insert new user
          | Generate user ID
          |
          v
    APPLICATION SERVER
          |
          | HTTP 201 Created
          |
          v
       CLIENT
```

### API Example

Request:

```http
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
```

```json
{
  "name": "Pradeep",
  "role": "Cloud Engineer"
}
```

Response:

```http
HTTP/1.1 201 Created
Location: /api/users/102
Content-Type: application/json
```

```json
{
  "id": 102,
  "name": "Pradeep",
  "role": "Cloud Engineer",
  "message": "User created successfully"
}
```

### Real-Time Scenario

A customer registers on an e-commerce website.

The application saves the customer information in the database and returns HTTP 201.

### DevOps Practical Example

Test a POST API using curl:

```bash
curl -i -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":"Pradeep","role":"Cloud Engineer"}'
```

**DevOps takeaway:** HTTP 201 confirms successful resource creation. When troubleshooting, verify that the database transaction was committed and duplicate requests are handled correctly.

---

# 5. HTTP 202 – Accepted

### What is 202 Accepted?

HTTP 202 means the server accepted the request for processing, but processing has not necessarily completed.

It is commonly used in asynchronous operations and background jobs.

### Visual Example

```text
       CLIENT
          |
          | POST /api/reports
          |
          v
    APPLICATION SERVER
          |
          | Accept request
          |
          v
       MESSAGE QUEUE
          |
          | Job submitted
          |
          v
    HTTP 202 ACCEPTED
          |
          v
       CLIENT

          |
          | Background processing
          v
       WORKER
          |
          | Generate report
          |
          v
        DATABASE / STORAGE
          |
          | Save completed report
          v
       JOB COMPLETED
```

### API Example

Request:

```http
POST /api/reports HTTP/1.1
Host: api.example.com
Content-Type: application/json
```

```json
{
  "report_type": "monthly_expenses"
}
```

Response:

```http
HTTP/1.1 202 Accepted
Content-Type: application/json
```

```json
{
  "job_id": "JOB-1001",
  "status": "PROCESSING",
  "message": "Report generation accepted"
}
```

### Real-Time Scenario

An application receives a request to generate a large monthly financial report.

Instead of making the customer wait, the application:

1. Accepts the request.
2. Adds a job to a message queue.
3. Returns HTTP 202.
4. A background worker processes the job.
5. The customer checks the job status later.

### DevOps Practical Example

In production, you may monitor:

- Message queue depth.
- Worker availability.
- Job processing time.
- Failed background jobs.
- Application logs.

**DevOps takeaway:** HTTP 202 does not mean the requested operation has completed. It only confirms acceptance for processing.

---

# 6. HTTP 204 – No Content

### What is 204 No Content?

HTTP 204 means the server successfully processed the request but has no response body to return.

It is commonly used for DELETE requests and successful update operations where no response data is required.

### Visual Example

```text
       CLIENT
          |
          | DELETE /api/users/101
          |
          v
    APPLICATION SERVER
          |
          | Process delete request
          |
          v
        DATABASE
          |
          | Delete user record
          |
          v
    APPLICATION SERVER
          |
          | HTTP 204 No Content
          | No response body
          |
          v
       CLIENT
```

### API Example

Request:

```http
DELETE /api/users/101 HTTP/1.1
Host: api.example.com
```

Response:

```http
HTTP/1.1 204 No Content
```

There is no response body.

### Real-Time Scenario

An administrator deletes an inactive employee account.

The application deletes the record and returns HTTP 204 to indicate success without sending additional data.

### DevOps Practical Example

```bash
curl -i -X DELETE http://localhost:8080/api/users/101
```

Expected response:

```http
HTTP/1.1 204 No Content
```

**DevOps takeaway:** A 204 response is successful. Do not treat an empty response body as an application failure.

---

# 7. Quick Comparison

| Code | Meaning | Request Example | Response Body |
|---|---|---|---|
| 200 | OK | GET | Usually present |
| 201 | Created | POST | Often present |
| 202 | Accepted | POST | Often present |
| 204 | No Content | DELETE | Not present |

# 8. Production Troubleshooting – Senior DevOps Perspective

Imagine an application is deployed on AWS EC2 behind an Application Load Balancer.

```text
              INTERNET
                  |
                  v
          AWS APPLICATION LB
                  |
                  v
              EC2 INSTANCE
                  |
                  v
             NGINX SERVER
                  |
                  v
          APPLICATION (8080)
                  |
                  v
               MYSQL
```

### Scenario 1: API returns HTTP 200

Check:

```bash
curl -i http://localhost:8080/health
```

Verify application response and dependency health.

### Scenario 2: API returns HTTP 201

Check application logs and database records to confirm resource creation.

```bash
sudo journalctl -u myapp -f
```

### Scenario 3: API returns HTTP 202

Check whether background jobs are actually being processed.

Monitor queue depth, worker logs and processing latency.

### Scenario 4: API returns HTTP 204

Confirm that the operation succeeded. Do not expect a response body.

### Important DevOps Commands

Check Nginx:

```bash
sudo systemctl status nginx
```

Check application:

```bash
sudo systemctl status myapp
```

Check application logs:

```bash
sudo journalctl -u myapp -n 100 --no-pager
```

Check listening ports:

```bash
sudo ss -tulnp
```

Test API:

```bash
curl -v http://localhost:8080/health
```

# 9.DevOps Engineer Interview Questions

### Q1. What is the difference between HTTP 200 and HTTP 201?

**Answer:** HTTP 200 indicates that a request was successfully processed. HTTP 201 specifically indicates that a new resource was successfully created.

### Q2. What is the difference between HTTP 200 and HTTP 202?

**Answer:** HTTP 200 indicates successful processing of the request. HTTP 202 indicates that the request has been accepted for processing, but the actual operation may still be running.

### Q3. Can HTTP 204 have a response body?

**Answer:** No. HTTP 204 indicates successful processing with no response content.

### Q4. Does HTTP 200 always mean the application is healthy?

**Answer:** No. HTTP 200 only confirms that a particular request succeeded. An application may still have problems with database connections, background workers or other dependencies.

### Q5. How do you troubleshoot an API returning HTTP 200 but users report failures?

**Answer:**

1. Check API response payload.
2. Check application logs.
3. Verify database connectivity.
4. Check downstream microservices.
5. Review CloudWatch metrics.
6. Validate business logic and data consistency.

# 10. Key Takeaways

As a Senior Cloud / DevOps Engineer, remember:

- 200 – Request successfully processed.
- 201 – New resource created.
- 202 – Request accepted for asynchronous processing.
- 204 – Request successful, no response body.

Understanding these codes helps with API troubleshooting, production monitoring, application deployments and incident management.

---

**Next Learning File:** `02_3xx_Redirection_Codes.md`