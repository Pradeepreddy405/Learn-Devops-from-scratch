# 01 – DNS Fundamentals

## 1. What is DNS?

DNS stands for **Domain Name System**. It is a distributed naming system that helps translate human-readable domain names into information such as IP addresses.

Example:

```text
www.example.com  ->  203.0.113.10
```

A browser uses the resolved IP address to establish a network connection to the destination. DNS resolution and the subsequent HTTP/HTTPS connection are separate steps.

## 2. Why do we need DNS?

Computers communicate using IP addresses, but people find names easier to remember.

Without DNS, users might need to remember an IP address for every application. DNS provides a manageable naming layer and allows an application endpoint to change without requiring users to remember a new address.

Cloud example:

```text
app.devcloud.store -> public load balancer DNS name
```

The application can move to a different server or load balancer while the public domain remains the same.

## 3. Important terminology

| Term | Meaning |
|---|---|
| Domain name | Human-readable name, such as `example.com` |
| FQDN | Fully Qualified Domain Name, such as `api.example.com.` |
| DNS resolver | Service that looks up DNS answers for a client |
| Recursive resolver | Resolver that performs the lookup on behalf of a client |
| Authoritative nameserver | Server that provides the authoritative data for a DNS zone |
| DNS zone | Administrative portion of the DNS namespace |
| DNS record | Data stored in a zone, such as an A or MX record |
| TTL | Time to Live; how long a DNS answer may be cached |
| Delegation | Referral of DNS authority to another set of nameservers |
| Registrar | Company through which a domain is registered |

## 4. DNS hierarchy

DNS is hierarchical and distributed.

```text
                         Root (.)
                            |
             +--------------+--------------+
             |              |              |
            .com           .org           .in
             |
          example
             |
          www.example.com
```

- Root zone: top of the DNS hierarchy.
- TLD: top-level domain, such as `.com`, `.org`, or `.in`.
- Second-level domain: `example` in `example.com`.
- Subdomain/host name: `www` in `www.example.com`.

## 5. Recursive vs authoritative DNS

**Recursive resolver**
- Receives a query from a client.
- Checks its cache.
- If needed, follows DNS referrals to find an answer.
- Returns the result to the client.

**Authoritative nameserver**
- Holds DNS data for a zone.
- Returns authoritative answers for records in that zone.

Do not confuse a recursive resolver with an authoritative nameserver. They perform different roles, although some DNS software can provide both functions.

## 6. Registrar vs DNS hosting

| Domain registrar | DNS hosting provider |
|---|---|
| Registers the domain | Hosts and serves DNS records |
| Manages registration and renewal | Manages the DNS zone |
| Lets you set delegated nameservers | Provides authoritative nameservers |
| Example: a domain retailer | Example: Amazon Route 53 |

A domain can be registered with one company and use DNS hosting from another.

## 7. Public DNS vs private DNS

- **Public DNS:** names are resolvable by clients using the public DNS system.
- **Private DNS:** names are resolvable only within a configured private network or resolver environment, subject to its connectivity and DNS configuration.

AWS example: a Route 53 public hosted zone can serve public records, while a Route 53 private hosted zone can resolve internal names from associated VPCs.

## 8. Interview answer

**Question: What is DNS?**

DNS is a distributed naming system that translates domain names into DNS data, commonly IP addresses. When a client needs to access a domain, it queries a recursive resolver. The resolver checks its cache and, if necessary, follows the DNS hierarchy to an authoritative nameserver. It returns the answer to the client, which can then connect to the destination.

## 9. Knowledge check

1. What problem does DNS solve?
2. What is the difference between a recursive resolver and an authoritative nameserver?
3. What is a DNS zone?
4. Can a domain registrar and DNS hosting provider be different?
5. What is the difference between public and private DNS?

## 10. Key takeaway

DNS is the naming and discovery layer. A successful DNS lookup does not prove that the destination application is healthy; network connectivity, TLS, load balancer, and application checks are separate troubleshooting steps.
