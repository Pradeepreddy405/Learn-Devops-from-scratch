# HTTP 4xx – Client Error Status Codes

## 1. What are HTTP 4xx Status Codes?

HTTP 4xx status codes indicate that the server cannot or will not process a request because of an issue associated with the request.

As a Cloud / DevOps Engineer, these codes are important when troubleshooting:

- API authentication.
- Authorization and IAM.
- Security groups and access restrictions.
- Invalid API requests.
- Rate limiting.
- Application routing.

## 2. Understanding HTTP 4xx Codes

| Code | Meaning | Real-Time Scenario |
|---|---|---|
| 400 | Bad Request | Invalid JSON payload |
| 401 | Unauthorized | Missing or invalid authentication |
| 403 | Forbidden | User does not have permission |
| 404 | Not Found | Requested URL does not exist |
| 429 | Too Many Requests | API rate limit exceeded |

---

## 3. HTTP 400 – Bad Request

### Explanation

HTTP 400 indicates that the server cannot process the request because the request contains invalid syntax or invalid data.

### Visual Example

```text
CLIENT
   |
   | POST /api/users
   | Invalid JSON
   v
APPLICATION SERVER
   |
   | Validate request
   |
   | Invalid request
   v
HTTP 400 BAD REQUEST
   |
   v
CLIENT
```

### API Example

Request:

```http
POST /api/users
Content-Type: application/json
```

```json
{
  "name": "Pradeep",
  "age":
}
```

Response:

```http
HTTP/1.1 400 Bad Request
```

```json
{
  "error": "Invalid JSON request"
}
```

### Practical Example

```bash
curl -i -X POST http://localhost:8080/api/users \
-H "Content-Type: application/json" \
-d '{"name":'
```

### Real-Time Scenario

A developer sends an invalid JSON payload to a REST API.

The application rejects the request with HTTP 400.

**DevOps takeaway:** Check request payloads, API schemas, application validation and client-side integrations.

---

## 4. HTTP 401 – Unauthorized

### Explanation

HTTP 401 indicates that valid authentication credentials are missing or invalid.

The client must authenticate to access the protected resource.

### Visual Example

```text
CLIENT
   |
   | GET /api/profile
   | No valid token
   v
APPLICATION
   |
   | Validate token
   |
   | Authentication failed
   v
HTTP 401
   |
   v
CLIENT
```

### API Example

Request:

```http
GET /api/profile
```

Response:

```http
HTTP/1.1 401 Unauthorized
WWW-Authenticate: Bearer
```

```json
{
  "error": "Invalid or missing token"
}
```

### Practical Example

```bash
curl -i http://localhost:8080/api/profile
```

Test with a bearer token:

```bash
curl -i http://localhost:8080/api/profile \
-H "Authorization: Bearer YOUR_TOKEN"
```

### Real-Time Scenario

An application uses JWT authentication.

An expired or invalid JWT token causes the API to return HTTP 401.

**DevOps takeaway:** Verify token validity, authentication configuration, secrets and identity-provider connectivity.

---

## 5. HTTP 403 – Forbidden

### Explanation

HTTP 403 indicates that the server understood the request but refuses to authorize access.

The user may be authenticated but lacks permission.

### Visual Example

```text
CLIENT
   |
   | GET /admin
   | Valid authentication
   v
APPLICATION
   |
   | Check user permissions
   |
   | Access denied
   v
HTTP 403 FORBIDDEN
   |
   v
CLIENT
```

### API Example

```http
GET /admin
Authorization: Bearer VALID_TOKEN
```

Response:

```http
HTTP/1.1 403 Forbidden
```

```json
{
  "error": "You do not have permission"
}
```

### Practical Example

```bash
curl -i http://localhost:8080/admin \
-H "Authorization: Bearer VALID_TOKEN"
```

### Real-Time Scenario

An employee can access the user dashboard but cannot access the administrator dashboard.

The application returns HTTP 403.

### AWS Troubleshooting

Check:

- IAM policies.
- S3 bucket policies.
- Application authorization rules.
- Nginx access restrictions.
- AWS WAF rules.

**DevOps takeaway:** Authentication and authorization are different. A valid identity does not automatically mean permission to access a resource.

---

## 6. HTTP 404 – Not Found

### Explanation

HTTP 404 indicates that the requested resource or endpoint could not be found.

### Visual Example

```text
CLIENT
   |
   | GET /api/unknown
   v
NGINX / APPLICATION
   |
   | Search for requested endpoint
   |
   | Resource not found
   v
HTTP 404
   |
   v
CLIENT
```

### API Example

Request:

```http
GET /api/unknown
```

Response:

```http
HTTP/1.1 404 Not Found
```

```json
{
  "error": "Resource not found"
}
```

### Practical Example

```bash
curl -i http://localhost:8080/invalid-endpoint
```

### Real-Time Scenario

After a new application deployment, users receive 404 errors because the application endpoint has changed or Nginx is forwarding requests to the wrong path.

### DevOps Troubleshooting

```bash
sudo nginx -t
sudo systemctl status nginx
sudo journalctl -u nginx -n 100
```

Check application routes and reverse proxy configuration.

**DevOps takeaway:** Verify URL paths, application routes, Nginx location blocks and backend routing.

---

## 7. HTTP 429 – Too Many Requests

### Explanation

HTTP 429 indicates that the client has sent too many requests within a specific period.

It is commonly associated with rate limiting.

### Visual Example

```text
CLIENT
   |
   | Request 1
   | Request 2
   | Request 3
   | Request 4
   v
API GATEWAY / WAF
   |
   | Rate limit exceeded
   v
HTTP 429
   |
   v
CLIENT
```

### API Example

Response:

```http
HTTP/1.1 429 Too Many Requests
Retry-After: 60
```

```json
{
  "error": "Rate limit exceeded",
  "retry_after": 60
}
```

### Practical Example

```bash
for i in {1..20}; do
    curl -s -o /dev/null -w "%{http_code}\n" \
    http://localhost:8080/api/test
done
```

Note: This produces HTTP 429 only if the endpoint has a sufficiently restrictive rate limit configured.

### Real-Time Scenario

An application allows 100 requests per minute per client.

A client sends 200 requests within one minute.

The API gateway rejects excess requests with HTTP 429.

### DevOps Troubleshooting

Check:

- API Gateway throttling settings.
- AWS WAF rate-based rules.
- Nginx rate-limiting configuration.
- Application rate limits.
- Client retry behavior.

**DevOps takeaway:** Investigate traffic patterns and rate-limit policies. Clients should respect `Retry-After` and use controlled retries with backoff.

---

## 8. Comparison Table

| Code | Meaning | Common Cause |
|---|---|---|
| 400 | Bad Request | Invalid request |
| 401 | Unauthorized | Authentication failure |
| 403 | Forbidden | Permission denied |
| 404 | Not Found | Missing resource |
| 429 | Too Many Requests | Rate limiting |

## 9.DevOps Interview Questions

**Q1. Difference between 401 and 403?**

401 means authentication is missing or invalid. 403 means the server refuses access, usually because the authenticated identity lacks permission.

**Q2. What causes HTTP 400?**

Invalid JSON, missing mandatory fields, malformed request parameters or invalid request syntax.

**Q3. What causes HTTP 404 after deployment?**

Incorrect application routes, Nginx proxy configuration, missing files or incorrect deployment paths.

**Q4. How do you troubleshoot HTTP 403 in AWS?**

Check IAM policies, resource policies, WAF rules, application authorization and other access restrictions.

**Q5. How do you handle HTTP 429?**

Review rate limits, identify excessive traffic, apply exponential backoff and optimize client request frequency.

## 10. Useful DevOps Commands

```bash
curl -i http://localhost:8080/api/test
curl -v http://localhost:8080/api/test
sudo journalctl -u nginx -n 100
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

**Key takeaway:** 4xx errors generally indicate a request, authentication, authorization, routing or rate-limiting problem. Investigate the actual source before assuming the application server is faulty.

Next: `04_5xx_Server_Error_Codes.md`
