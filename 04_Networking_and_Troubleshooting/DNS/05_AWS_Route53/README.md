# 05 – AWS Route 53

## 1. What is Amazon Route 53?

Amazon Route 53 is AWS's scalable DNS web service. It can register domains, host public and private DNS zones, route DNS queries, and perform health checks.

Official documentation: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html

## 2. Core components

| Component | Purpose |
|---|---|
| Hosted zone | Container for DNS records for a domain or subdomain |
| Record | DNS data such as A, AAAA, CNAME, MX, TXT, or Alias |
| Public hosted zone | Provides DNS data through the public DNS system |
| Private hosted zone | Provides DNS data to associated VPCs |
| Health check | Monitors configured endpoints or other health-check targets |
| Routing policy | Determines which DNS response Route 53 returns |
| Alias record | Route 53 feature that points to supported AWS resources or eligible records |

## 3. Public hosted zone

A public hosted zone contains records intended to be resolvable through public DNS.

Typical architecture:

```text
Internet user
     |
Recursive DNS resolver
     |
Route 53 public hosted zone
     |
Alias / DNS record
     |
Application Load Balancer
     |
EC2 / containers / application
```

## 4. Private hosted zone

A private hosted zone is associated with one or more VPCs. It allows resources using the VPC's DNS resolution to resolve internal names.

Example internal names:

```text
api.internal.example.com
db.internal.example.com
```

Check VPC DNS support and DNS hostnames settings, VPC associations, resolver configuration, and network connectivity when private DNS does not resolve.

## 5. Domain registration and nameserver delegation

A domain can be registered at one provider and use Route 53 for DNS hosting.

General process:

1. Register or own a domain.
2. Create a public hosted zone in Route 53.
3. Note the four Route 53 authoritative nameservers assigned to the zone.
4. At the domain registrar, update the domain's delegated nameservers to those Route 53 nameservers.
5. Create the required DNS records in the hosted zone.
6. Verify delegation and answers using `dig`.

Example checks:

```bash
dig example.com NS
dig +trace example.com
dig www.example.com A
```

Important: before changing nameservers, recreate all required existing DNS records in the new hosted zone. This includes website records, email MX records, SPF/DKIM/DMARC TXT records, verification records, and any subdomain records. A nameserver change changes which DNS provider is authoritative; it does not transfer domain ownership.

## 6. Common Route 53 record examples

### A record

Maps a name to an IPv4 address.

```text
Record name: app.example.com
Record type: A
Value:       192.0.2.10
```

### CNAME record

Aliases one name to another DNS name.

```text
Record name: www.example.com
Record type: CNAME
Value:       app.example.com
```

### Alias to an Application Load Balancer

In the Route 53 console, create an A record and enable Alias, then select the supported ALB target in the appropriate Region.

An Alias is a Route 53 feature, not a standard DNS record type. It can support zone-apex routing to eligible AWS resources, unlike a standard CNAME.

## 7. AWS CLI examples

The AWS CLI must be configured with an identity that has the required Route 53 permissions.

List hosted zones:

```bash
aws route53 list-hosted-zones
```

List records in a hosted zone:

```bash
aws route53 list-resource-record-sets --hosted-zone-id ZONE_ID
```

Get a hosted zone:

```bash
aws route53 get-hosted-zone --id ZONE_ID
```

Replace `ZONE_ID` with the actual hosted zone ID. Do not paste account credentials into scripts or GitHub.

## 8. Route 53 and application architecture

Common patterns:
- Public domain -> Route 53 -> Application Load Balancer -> application targets.
- Public domain -> Route 53 Alias -> CloudFront distribution -> origin.
- Internal service name -> Route 53 private hosted zone -> private load balancer or service endpoint.

DNS directs clients to an endpoint. Security groups, routing, TLS certificates, load balancer listeners, target health, and application configuration must also be correct.

## 9. Security and operational considerations

- Apply least-privilege IAM permissions.
- Protect registrar accounts with strong authentication.
- Keep an inventory of DNS records and ownership.
- Review changes before applying them.
- Monitor important endpoints and DNS behavior.
- Avoid deleting a hosted zone until its records and delegation dependencies are understood.
- Do not publish internal-only names or sensitive infrastructure details unnecessarily.

## 10. Interview questions

1. What is Amazon Route 53?
2. What is a hosted zone?
3. What is the difference between public and private hosted zones?
4. How do you point a domain registered at another provider to Route 53?
5. What is an Alias record?
6. How would you point a domain to an ALB?
7. What would you check if a private hostname does not resolve?

## 11. Key takeaway

Route 53 provides managed DNS and routing capabilities. A correct DNS record is only one part of application availability; validate the complete path from DNS through the AWS network and application.
