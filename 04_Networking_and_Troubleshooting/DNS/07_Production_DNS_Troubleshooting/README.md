# 07 – Production DNS Troubleshooting

This module provides a structured method for diagnosing DNS and application-access incidents.

## 1. First principle: isolate the failing layer

A user saying "the website is down" does not automatically mean DNS is the problem.

Investigate in layers:

```text
Client
  |
DNS resolution
  |
Network route / firewall
  |
TCP connection
  |
TLS handshake
  |
Load balancer
  |
Backend target
  |
Application
  |
Database / dependencies
```

## 2. Initial information to collect

- Exact hostname and URL.
- Time the issue started and whether it is intermittent.
- Affected users, regions, networks, or environments.
- Recent DNS, registrar, infrastructure, certificate, or application changes.
- Expected destination and actual DNS answer.
- Exact error message and command output.

Do not make a DNS change until you have evidence that the DNS layer is involved.

## 3. First-response command sequence

Replace `app.example.com` with the affected hostname.

```bash
# Check A and AAAA answers
dig app.example.com A
dig app.example.com AAAA

# Check nameserver delegation
dig example.com NS

# Trace delegation
dig +trace app.example.com

# Compare with a public recursive resolver
dig @1.1.1.1 app.example.com

# Test HTTPS
curl -Iv https://app.example.com

# Inspect the route to the resolved address
ip route get RESOLVED_IP
```

Use the actual resolved IP in place of `RESOLVED_IP`.

## 4. Common incident patterns

### Scenario A: NXDOMAIN

**Symptom:** DNS response says the requested name does not exist.

Possible causes:
- Typo in hostname.
- Missing record.
- Record created in the wrong hosted zone.
- Incorrect delegation to another DNS provider.
- Record was deleted.

Checks:

```bash
dig app.example.com
dig example.com NS
dig +trace app.example.com
```

Remediation: confirm the intended zone is authoritative and create or correct the record through the approved change process.

### Scenario B: SERVFAIL

**Symptom:** Resolver reports that it could not complete the query.

Possible causes:
- Authoritative nameserver failure or misconfiguration.
- DNSSEC validation problem.
- Broken delegation or other DNS infrastructure issue.

Checks:

```bash
dig app.example.com
dig +trace app.example.com
dig +dnssec app.example.com
```

Compare results using more than one resolver. Do not disable DNSSEC as a first reaction; identify the validation or signing problem.

### Scenario C: Domain returns an old IP

Possible causes:
- Cached answer has not expired.
- Resolver or application has its own cache.
- Authoritative record was not updated.
- Some clients are querying a different delegated zone.

Checks:

```bash
dig app.example.com
dig @1.1.1.1 app.example.com
dig example.com NS
```

Compare the authoritative answer, recursive answers, and TTLs. Allow for caches to expire; changing the record again does not instantly clear every cache.

### Scenario D: Domain resolves but website is unavailable

DNS may be working correctly. Continue with:

```bash
curl -Iv https://app.example.com
nc -vz app.example.com 443
```

Then inspect:
- Security groups and network ACLs.
- Routes and firewall rules.
- ALB listener and target group health.
- TLS certificate and hostname match.
- Web server and application service.
- Application logs and dependencies.

### Scenario E: Internal hostname does not resolve in AWS

Check:
- Whether the Route 53 private hosted zone is associated with the correct VPC.
- VPC DNS support and DNS hostnames settings.
- Which resolver the EC2 instance is using.
- VPC routing and connectivity for hybrid DNS.
- Record name and private hosted-zone contents.

## 5. AWS-specific investigation

For a Route 53-hosted domain:
1. Confirm the domain's delegated nameservers at the registrar.
2. Compare them with the NS records assigned to the intended hosted zone.
3. Inspect the hosted-zone record set.
4. Confirm the record type, value, routing policy, and TTL.
5. For Alias records, confirm the selected AWS resource and Region.
6. For failover or latency routing, inspect health checks and routing configuration.
7. Check CloudTrail for relevant configuration changes, where available.

Useful AWS CLI commands:

```bash
aws route53 list-hosted-zones
aws route53 list-resource-record-sets --hosted-zone-id ZONE_ID
aws route53 get-hosted-zone --id ZONE_ID
```

## 6. Production incident checklist

- [ ] Confirm the exact affected hostname.
- [ ] Record incident start time and scope.
- [ ] Capture DNS response code, answer, and TTL.
- [ ] Compare multiple recursive resolvers.
- [ ] Verify authoritative nameservers and delegation.
- [ ] Check recent DNS changes and audit events.
- [ ] Test TCP and TLS connectivity.
- [ ] Check load balancer and backend health.
- [ ] Check application logs and dependent services.
- [ ] Apply an approved remediation.
- [ ] Verify from affected networks and regions.
- [ ] Document root cause and preventive actions.

## 7. Example incident report

**Incident:** `app.example.com` was unavailable to a subset of users.

**Impact:** Some users received an old destination address.

**Investigation:** Compared authoritative DNS data with recursive resolver responses and inspected TTL values. Confirmed that some resolvers still held the previous answer.

**Resolution:** Verified the intended authoritative record, avoided repeated unplanned changes, and monitored the affected resolvers as cached answers expired.

**Prevention:** Documented DNS ownership, change procedure, TTL planning, and post-change validation.

This is an illustrative example, not a claim about a real incident.

## 8. Senior DevOps interview response

I first establish whether the failure is DNS-related or occurs later in the connection path. I check the response code, returned records, TTL, and authoritative delegation using `dig`. I compare recursive resolvers and inspect recent DNS changes. If resolution is correct, I move to routing, firewall, TCP, TLS, load balancer, target health, and application logs. I preserve command output and timestamps, make changes through the approved process, and verify recovery from the affected locations.
