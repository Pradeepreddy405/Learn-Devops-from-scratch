# HTTP Status Codes – Cloud & DevOps

## Overview

HTTP Status Codes are returned by a web server or application to indicate the result of an HTTP request.

As a Cloud and DevOps Engineer, understanding HTTP status codes is important for troubleshooting websites, APIs, application servers, Nginx, Apache, AWS Load Balancers, and production environments.

## HTTP Status Code Categories

| Category | Description                    | Meaning                                                 |
| -------- | ------------------------------ | ------------------------------------------------------- |
| 1xx      | Request processing information | Informational                                           |
| 2xx      | Success                        | Request completed successfully                          |
| 3xx      | Redirection                    | Client needs to follow a redirect or use cached content |
| 4xx      | Client Error                   | Problem with the request or client permissions          |
| 5xx      | Server Error                   | Server failed to complete the request                   |

## 1. 2xx – Success Codes

The request was successfully received and processed.

| Status Code | Name       | Description                          |
| ----------- | ---------- | ------------------------------------ |
| 200         | OK         | Request successful                   |
| 201         | Created    | New resource created                 |
| 202         | Accepted   | Request accepted for processing      |
| 204         | No Content | Request successful, no response body |

## 2. 3xx – Redirection Codes

The requested resource requires redirection or the client can use a cached response.

| Status Code | Name               | Description                               |
| ----------- | ------------------ | ----------------------------------------- |
| 301         | Moved Permanently  | Resource permanently moved                |
| 302         | Found              | Temporary redirection                     |
| 304         | Not Modified       | Use cached resource                       |
| 307         | Temporary Redirect | Temporary redirect preserving HTTP method |
| 308         | Permanent Redirect | Permanent redirect preserving HTTP method |

## 3. 4xx – Client Error Codes

The server received the request but cannot or will not process it because of a client-side issue.

| Status Code | Name               | Description                           |
| ----------- | ------------------ | ------------------------------------- |
| 400         | Bad Request        | Invalid request                       |
| 401         | Unauthorized       | Authentication required or failed     |
| 403         | Forbidden          | Access denied                         |
| 404         | Not Found          | Requested resource not found          |
| 405         | Method Not Allowed | HTTP method not supported             |
| 408         | Request Timeout    | Request timed out                     |
| 409         | Conflict           | Request conflicts with resource state |
| 413         | Content Too Large  | Request body is too large             |
| 429         | Too Many Requests  | Rate limit exceeded                   |

## 4. 5xx – Server Error Codes

The server failed to complete a valid request.

| Status Code | Name                  | Description                        |
| ----------- | --------------------- | ---------------------------------- |
| 500         | Internal Server Error | Unexpected application error       |
| 501         | Not Implemented       | Functionality not supported        |
| 502         | Bad Gateway           | Invalid response from upstream     |
| 503         | Service Unavailable   | Service temporarily unavailable    |
| 504         | Gateway Timeout       | Upstream server response timed out |

## 5. Important Commands for DevOps Engineers

### Check HTTP response headers

```bash
curl -I https://example.com
```

### Display HTTP status code only

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
```

### Follow redirects

```bash
curl -IL http://example.com
```

### Test an application running locally

```bash
curl -I http://localhost:8080
```

## 6. Production Troubleshooting

| Status Code | Common Investigation                             |
| ----------- | ------------------------------------------------ |
| 400         | Check request payload and API parameters         |
| 401         | Check authentication and access tokens           |
| 403         | Check permissions and access policies            |
| 404         | Check URL, routing and application endpoints     |
| 500         | Check application logs and exceptions            |
| 502         | Check Nginx, upstream and backend connectivity   |
| 503         | Check application health and server capacity     |
| 504         | Check backend response time and network timeouts |

### Useful Linux Commands

Check Nginx status:

```bash
sudo systemctl status nginx
```

Check Nginx error logs:

```bash
sudo tail -f /var/log/nginx/error.log
```

Check application logs:

```bash
sudo journalctl -u myapp -f
```

Check listening ports:

```bash
sudo ss -tulnp
```

## 7. Key Takeaways

- 2xx – Request successful.
- 3xx – Redirection.
- 4xx – Client-side request or permission issue.
- 5xx – Server-side processing failure.

## Learning Objective

Understand HTTP communication, identify HTTP response codes, and troubleshoot application connectivity issues in real-world Cloud and DevOps environments.
