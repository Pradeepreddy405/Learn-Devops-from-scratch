# 04 – Linux DNS Troubleshooting

This module covers common Linux commands and a repeatable method for investigating DNS issues.

## 1. Check DNS resolution with `dig`

```bash
dig example.com
```

Show only the answer:

```bash
dig example.com +noall +answer
```

Query a record type:

```bash
dig example.com A
dig example.com AAAA
dig example.com MX
dig example.com TXT
dig example.com NS
dig example.com SOA
```

Query a particular resolver:

```bash
dig @1.1.1.1 example.com
```

Trace DNS delegation:

```bash
dig +trace example.com
```

## 2. Use `nslookup`

```bash
nslookup example.com
```

Query a specific DNS server:

```bash
nslookup example.com 1.1.1.1
```

Query a record type:

```bash
nslookup -type=MX example.com
```

## 3. Use `host`

```bash
host example.com
host -t MX example.com
host -t NS example.com
host 192.0.2.10
```

## 4. Inspect resolver configuration

```bash
cat /etc/resolv.conf
```

This file may be generated or managed by NetworkManager, systemd-resolved, DHCP, or another network service. Avoid editing it directly without first identifying what manages it.

On systems using systemd-resolved:

```bash
resolvectl status
resolvectl query example.com
```

Some distributions do not include `resolvectl` or systemd-resolved.

## 5. Check local name resolution

```bash
getent hosts example.com
```

Check the host lookup order:

```bash
grep '^hosts:' /etc/nsswitch.conf
```

Inspect local static entries:

```bash
cat /etc/hosts
```

`getent` follows the system's configured name-service lookup path, so it can reveal differences between application/system lookup and a direct `dig` query.

## 6. Separate DNS from network and application checks

```bash
# DNS lookup
dig example.com

# Check route to an IP (replace with the actual resolved IP)
ip route get 192.0.2.10

# Test TCP connectivity to HTTPS
nc -vz example.com 443

# Test HTTP/TLS response
curl -Iv https://example.com
```

Do not treat `ping` as a definitive website health test. ICMP may be blocked even when HTTPS works.

## 7. Troubleshooting workflow

1. Confirm the exact hostname and record type.
2. Run `dig hostname A` and inspect status, answer, and TTL.
3. Query a second trusted resolver to compare results.
4. Check the authoritative nameservers and delegation with `dig NS` and `dig +trace`.
5. Inspect `/etc/resolv.conf`, `resolvectl status`, and `/etc/hosts`.
6. If DNS returns the expected address, test routing, TCP port, TLS, load balancer, and application.
7. Record the timestamp, affected hostname, resolver, query result, and changes made.

## 8. Common symptoms

| Symptom | Possible cause | What to check |
|---|---|---|
| `NXDOMAIN` | Name or record does not exist | Hostname spelling, zone, record |
| `SERVFAIL` | Resolver or authoritative failure, DNSSEC issue | `dig +trace`, DNSSEC validation, authoritative service |
| Timeout | Resolver unreachable or DNS traffic blocked | Resolver IP, UDP/TCP 53, network ACL/firewall |
| Wrong IP | Stale cache or incorrect record | TTL, authoritative answer, resolver comparison |
| Only one server fails | Local resolver or host configuration | `/etc/resolv.conf`, `getent`, `/etc/hosts` |
| DNS works but website fails | Network or application issue | TCP 443, TLS, ALB, targets, application logs |

## 9. Useful DNS ports

- UDP port 53: commonly used for DNS queries and responses.
- TCP port 53: used for larger responses, truncation fallback, and zone transfers where permitted.

Firewalls and security controls must allow the required DNS traffic to the configured resolver.

## 10. Practice lab

Run the following commands and save the outputs in your lab notes:

```bash
dig example.com
dig example.com A
dig example.com NS
dig example.com MX
dig +trace example.com
nslookup example.com
host example.com
cat /etc/resolv.conf
getent hosts example.com
```

Compare the results. Note which resolver answered, the returned record, TTL, and DNS status.

## 11. Interview answer

I start by confirming the hostname and querying it with `dig`. I inspect the response code, answer, and TTL. If necessary, I compare results from another resolver and trace delegation to the authoritative nameservers. I also inspect the Linux resolver configuration and local host files. If DNS returns the correct address, I continue troubleshooting the network, TLS, load balancer, and application layers.
