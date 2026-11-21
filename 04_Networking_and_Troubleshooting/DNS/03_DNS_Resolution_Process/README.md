# 03 – DNS Resolution Process

## 1. What happens when a user enters a URL?

Example URL:

```text
https://www.example.com/products
```

The browser needs to resolve the hostname `www.example.com` before it can connect to the destination. The URL path `/products` is not part of the DNS lookup.

## 2. High-level flow

```text
User / Browser
      |
      v
Browser and OS DNS caches
      |
      v
Recursive DNS resolver
      |
      +---- Root DNS servers
      |
      +---- TLD DNS servers (.com)
      |
      +---- Authoritative DNS servers (example.com)
      |
      v
DNS answer returned to resolver
      |
      v
Answer returned to client
      |
      v
Client connects to destination IP
```

## 3. Step-by-step resolution

1. The user enters a URL.
2. The browser extracts the hostname.
3. The browser and operating system may check their DNS caches.
4. If no usable cached answer exists, the operating system sends a query to its configured DNS resolver.
5. The recursive resolver checks its cache.
6. If it needs to resolve the name, it queries a root nameserver.
7. The root server returns a referral to the relevant TLD nameservers, such as `.com`.
8. The resolver queries a TLD nameserver.
9. The TLD server returns a referral to the domain's authoritative nameservers.
10. The resolver queries an authoritative nameserver for the requested record.
11. The authoritative server returns the record or an appropriate DNS response.
12. The resolver caches the answer according to its TTL and returns it to the client.
13. The client uses the returned address to establish a connection.

The resolver normally follows referrals; the root and TLD servers do not usually return the final website IP address.

## 4. Recursive and iterative queries

- A **recursive query** asks the resolver to return a final answer or an error.
- An **iterative query** allows a DNS server to return the best information it has, often a referral to another server.

A typical client asks its recursive resolver for a recursive answer. The resolver then performs iterative queries through the DNS hierarchy.

## 5. Caching

DNS answers can be cached by:
- Browser
- Operating system or local DNS service
- Corporate or ISP recursive resolver
- Other DNS infrastructure

Caching reduces lookup latency and DNS traffic. The TTL indicates how long an answer may be cached, but individual software and resolver behavior can vary.

## 6. Useful commands

Query a recursive resolver:

```bash
dig www.example.com
```

Show the answer section:

```bash
dig www.example.com +noall +answer
```

Trace referrals through the DNS hierarchy:

```bash
dig +trace www.example.com
```

Query a specific resolver:

```bash
dig @1.1.1.1 www.example.com
```

The `dig +trace` command performs iterative lookups from the root and can help investigate delegation. Network restrictions may prevent it from working in some environments.

## 7. DNS response codes

| Code | Meaning | Typical interpretation |
|---|---|---|
| NOERROR | No DNS protocol error | Requested name may exist; inspect answer section |
| NXDOMAIN | Name does not exist | Check spelling, zone, record, and delegation |
| SERVFAIL | Server failed to complete the query | Investigate authoritative DNS, DNSSEC, or resolver issues |
| REFUSED | Server refused the query | Check query policy and server configuration |
| NOERROR with no answer | Name exists but requested record may not | Check record type and zone data |

## 8. DNS resolution vs application connectivity

DNS resolution only provides DNS data. It does not prove:
- The IP is reachable.
- A security group or firewall permits traffic.
- The load balancer has healthy targets.
- The application is running.
- TLS certificates are valid.

After DNS lookup, test the next layers:

```bash
curl -Iv https://www.example.com
```

## 9. Interview answer

When a user enters a domain, the client checks available caches and then queries its configured recursive resolver. If the resolver does not have a cached answer, it follows referrals from the root to the TLD and then to the authoritative nameserver. The authoritative server returns the requested record. The resolver caches and returns the answer, after which the client can connect to the destination.

## 10. Knowledge check

1. What is the role of the root DNS server?
2. What does a TLD nameserver provide?
3. Which server holds the authoritative zone data?
4. What does `dig +trace` show?
5. Why can a DNS lookup succeed while a website is still unavailable?
