# Practical Lab Checklist

Use this checklist as you progress. Tick items only after you have completed and understood them.

## Networking
- [ ] Identify local IP addresses, routes, listening ports, and active connections.
- [ ] Test DNS resolution and TCP connectivity separately.
- [ ] Explain the path from a browser to a public application.

## Proxy and Nginx
- [ ] Explain forward proxy vs reverse proxy without notes.
- [ ] Install Nginx on a Linux VM.
- [ ] Serve a static page.
- [ ] Configure Nginx to proxy to a private backend.
- [ ] Validate configuration with `nginx -t` before reloading.
- [ ] Diagnose a deliberate 502 error.

## Load balancing
- [ ] Configure an Nginx upstream with two or more backends.
- [ ] Observe request distribution.
- [ ] Stop one backend and observe behavior.
- [ ] Build an AWS ALB with a target group and health checks.

## DNS and TLS
- [ ] Query A, AAAA, CNAME, NS, MX, and TXT records.
- [ ] Explain recursive vs authoritative DNS.
- [ ] Inspect a TLS certificate using `openssl s_client`.
- [ ] Explain where TLS terminates in your architecture.

## System design
- [ ] Design a multi-AZ web application.
- [ ] Identify single points of failure.
- [ ] Explain horizontal vs vertical scaling.
- [ ] Identify cache consistency and invalidation risks.
- [ ] Document monitoring, backup, restore, and recovery objectives.
