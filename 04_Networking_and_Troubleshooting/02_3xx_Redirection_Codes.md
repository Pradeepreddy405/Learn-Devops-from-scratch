# HTTP 3xx – Redirection Status Codes

## 1. What are HTTP 3xx Status Codes?

HTTP 3xx status codes indicate that the client needs to take additional action to complete a request, usually by following a redirect to another URL.

As a Cloud / DevOps Engineer, 3xx codes are important when working with:

- Nginx web server redirects.
- HTTP to HTTPS redirection.
- Domain migration.
- Load balancers.
- CDN and CloudFront.
- Browser and API caching.

## 2. Understanding HTTP 3xx Codes

| Code | Meaning | Real-Time Scenario |
|---|---|---|
| 301 | Moved Permanently | Old domain redirected to new domain |
| 302 | Found (Temporary Redirect) | Temporary URL redirection |
| 304 | Not Modified | Browser uses cached content |
| 307 | Temporary Redirect | Redirect while preserving HTTP method |
| 308 | Permanent Redirect | Permanent redirect while preserving HTTP method |

---

## 3. HTTP 301 – Moved Permanently

### Explanation

HTTP 301 indicates that a resource has permanently moved to a new URL.

Clients and search engines may update their stored URL to the new location.

### Visual Example

```text
CLIENT
   |
   | GET http://example.com
   v
NGINX SERVER
   |
   | HTTP 301
   | Location: https://example.com
   v
CLIENT
   |
   | GET https://example.com
   v
APPLICATION
   |
   | HTTP 200 OK
   v
CLIENT
```

### API Example

Request:

```http
GET http://example.com
```

Response:

```http
HTTP/1.1 301 Moved Permanently
Location: https://example.com
```

### Nginx Practical Example

Configure HTTP to HTTPS redirection:

```nginx
server {
    listen 80;
    server_name example.com;

    return 301 https://$host$request_uri;
}
```

Check configuration:

```bash
sudo nginx -t
```

Reload Nginx:

```bash
sudo systemctl reload nginx
```

Test:

```bash
curl -I http://example.com
```

Expected result:

```http
HTTP/1.1 301 Moved Permanently
Location: https://example.com/
```

### Real-Time Scenario

An organization migrates its website from:

`http://old-example.com`

to:

`https://example.com`

The DevOps team configures a permanent redirect so visitors reach the new URL.

**Interview takeaway:** 301 is used for permanent URL changes.

---

## 4. HTTP 302 – Found (Temporary Redirect)

### Explanation

HTTP 302 indicates that the requested resource is temporarily available at another URL.

The original URL remains valid.

### Visual Example

```text
CLIENT
   |
   | GET /dashboard
   v
APPLICATION
   |
   | HTTP 302
   | Location: /login
   v
CLIENT
   |
   | GET /login
   v
LOGIN PAGE
   |
   | HTTP 200
   v
CLIENT
```

### API Example

```http
HTTP/1.1 302 Found
Location: /login
```

### Nginx Example

```nginx
location = /maintenance {
    return 302 /maintenance-page.html;
}
```

Test:

```bash
curl -I http://localhost/maintenance
```

### Real-Time Scenario

During temporary maintenance, users are redirected to a maintenance page.

**Interview takeaway:** 302 is a temporary redirect. Depending on the client, the HTTP method may change when following it.

---

## 5. HTTP 304 – Not Modified

### Explanation

HTTP 304 indicates that the requested resource has not changed since the client's cached version.

The browser can reuse its cached content instead of downloading it again.

### Visual Example

```text
CLIENT / BROWSER
       |
       | GET /style.css
       | If-None-Match: "abc123"
       v
     SERVER
       |
       | Compare ETag
       |
       | Resource unchanged
       v
   HTTP 304
       |
       v
CLIENT USES CACHED FILE
```

### API Example

Request:

```http
GET /style.css HTTP/1.1
If-None-Match: "abc123"
```

Response:

```http
HTTP/1.1 304 Not Modified
ETag: "abc123"
```

### Practical Example

```bash
curl -i -H 'If-None-Match: "abc123"' http://localhost/style.css
```

Note: This example returns 304 only if the server has a matching ETag and the resource has not changed.

### Real-Time Scenario

A user visits an application repeatedly.

The browser already has CSS, JavaScript and image files cached. The server returns 304 when those resources have not changed.

**Interview takeaway:** 304 reduces bandwidth and improves application performance.

---

## 6. HTTP 307 – Temporary Redirect

### Explanation

HTTP 307 indicates a temporary redirect.

Unlike 302, HTTP 307 guarantees that the original HTTP method and request body are preserved when following the redirect.

### Visual Example

```text
CLIENT
   |
   | POST /payment
   v
SERVER
   |
   | HTTP 307
   | Location: /new-payment
   v
CLIENT
   |
   | POST /new-payment
   | Same request body
   v
NEW PAYMENT ENDPOINT
```

### API Example

Request:

```http
POST /payment
```

Response:

```http
HTTP/1.1 307 Temporary Redirect
Location: /new-payment
```

### Practical Example

```bash
curl -i -L -X POST http://localhost/payment \
-H "Content-Type: application/json" \
-d '{"amount":1000}'
```

### Real-Time Scenario

A payment API is temporarily moved to another endpoint.

The original POST method and request payload must be preserved.

**Interview takeaway:** 307 is a temporary redirect that preserves the HTTP method.

---

## 7. HTTP 308 – Permanent Redirect

### Explanation

HTTP 308 indicates that a resource has permanently moved to another URL.

Unlike 301, HTTP 308 guarantees preservation of the original HTTP method and request body.

### Visual Example

```text
CLIENT
   |
   | POST /api/v1/orders
   v
OLD API SERVER
   |
   | HTTP 308
   | Location: /api/v2/orders
   v
CLIENT
   |
   | POST /api/v2/orders
   | Same request body
   v
NEW API SERVER
```

### API Example

Response:

```http
HTTP/1.1 308 Permanent Redirect
Location: /api/v2/orders
```

### Practical Example

```bash
curl -i -L -X POST http://localhost/api/v1/orders \
-H "Content-Type: application/json" \
-d '{"product":"Laptop"}'
```

### Real-Time Scenario

An organization permanently migrates its API endpoint from v1 to v2 while preserving POST requests.

**Interview takeaway:** 308 is a permanent redirect that preserves the HTTP method.

---

## 8. Comparison Table

| Code | Redirect Type | Method Preservation |
|---|---|---|
| 301 | Permanent | Not guaranteed |
| 302 | Temporary | Not guaranteed |
| 304 | Cache validation | Not applicable |
| 307 | Temporary | Guaranteed |
| 308 | Permanent | Guaranteed |

## 9.DevOps Interview Questions

**Q1. Difference between 301 and 302?**

301 is a permanent redirect; 302 is a temporary redirect.

**Q2. Difference between 301 and 308?**

Both are permanent redirects, but 308 guarantees preservation of the original HTTP method and request body.

**Q3. What is HTTP 304?**

It indicates that the resource has not changed, allowing the client to use its cached version.

**Q4. Difference between 302 and 307?**

307 guarantees that the original HTTP method and body are preserved. 302 does not guarantee this.

**Q5. How do you troubleshoot redirect loops?**

1. Check Nginx configuration.
2. Verify HTTP-to-HTTPS rules.
3. Check load balancer listener rules.
4. Review forwarded headers such as `X-Forwarded-Proto`.
5. Check application redirect logic.
6. Test using `curl -IL`.

## 10. Useful DevOps Commands

```bash
curl -I http://example.com
curl -IL http://example.com
sudo nginx -t
sudo systemctl status nginx
sudo journalctl -u nginx -n 100
```

**Key takeaway:** Understand redirect behavior, URL changes, HTTP method preservation and caching.

Next: `03_4xx_Client_Error_Codes.md`
