# DNS & Domain Naming Services – Cloud and DevOps

This module explains Domain Name System (DNS) from fundamentals to AWS implementation, Linux troubleshooting, production operations, and Terraform automation.

## Learning objectives
- Understand how domain names are translated into IP addresses.
- Explain DNS resolution, delegation, caching, TTL, and common record types.
- Troubleshoot DNS issues from Linux.
- Configure public and private DNS with Amazon Route 53.
- Understand Route 53 routing policies and health checks.
- Automate DNS infrastructure using Terraform.

## Learning path

| No. | Topic | What you will learn |
|---|---|---|
| 01 | [DNS Fundamentals](01_DNS_Fundamentals/README.md) | DNS purpose, hierarchy, resolver roles, terminology |
| 02 | [DNS Record Types](02_DNS_Record_Types/README.md) | A, AAAA, CNAME, MX, TXT, NS, SOA, PTR, SRV, CAA |
| 03 | [DNS Resolution Process](03_DNS_Resolution_Process/README.md) | Recursive lookup, root, TLD, authoritative DNS, caching |
| 04 | [Linux DNS Troubleshooting](04_Linux_DNS_Troubleshooting/README.md) | `dig`, `nslookup`, `host`, resolver configuration |
| 05 | [AWS Route 53](05_AWS_Route53/README.md) | Hosted zones, records, delegation, public/private DNS |
| 06 | [Route 53 Routing Policies](06_Route53_Routing_Policies/README.md) | Simple, weighted, latency, failover, geolocation |
| 07 | [Production DNS Troubleshooting](07_Production_DNS_Troubleshooting/README.md) | Incident workflow, failure patterns, diagnosis |
| 08 | [Terraform DNS Automation](08_Terraform_DNS_Automation/README.md) | Route 53 hosted zones and records as code |

## Recommended practice environment
- A Linux machine or Amazon Linux 2023 EC2 instance.
- AWS account with permission to view/create Route 53 resources.
- Terraform installed for the final module.
- A domain name is optional for the initial learning exercises. Use a domain you own before changing public DNS.

## Important safety notes
- Do not change production nameservers or DNS records during practice.
- Before changing nameservers, copy required existing records (website, email, verification, and other service records).
- A DNS change may be affected by TTL and caches. Reverting a record does not guarantee every client immediately sees the old value.
- Never commit AWS credentials, private keys, Terraform state files, or secrets to GitHub.

## How to use this repository
Read the modules in order. Run commands in a lab environment, record the expected output, and document any errors and their resolution. For AWS and Terraform labs, review the plan and understand the impact before applying changes.

## Interview preparation
For every topic, practise explaining:
1. What the technology does.
2. Why it is required.
3. How it works.
4. How you implement it in AWS.
5. How you troubleshoot it during a production incident.
