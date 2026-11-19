# AWS Route 53 
## Table of Contents

Introduction
Key Concepts
Types of Hosted Zones
DNS Records
Routing Policies
Health Checks & Failover
Domain Registration
Integration with Other AWS Services
Best Practices



## 1. Introduction

AWS Route 53 is Amazon’s scalable and highly available Domain Name System (DNS) web service. It is used to:

Register domain names

Route internet traffic to AWS resources (EC2, S3, CloudFront)

Monitor the health of resources

Enable highly available and fault-tolerant applications

Think of Route 53 as the phone book of the internet — translating human-readable domain names (like example.com) into IP addresses that computers use.

## 2. Key Concepts

Domain Name – The human-readable address (example.com).

DNS (Domain Name System) – Translates domain names into IP addresses.

Hosted Zone – A container for DNS records for a specific domain.

Record Set – Individual DNS record within a hosted zone.

Name Servers – Servers that respond to DNS queries for your domain.

## 3. Types of Hosted Zones
Hosted Zone Type	Purpose
Public	Route internet traffic to your domain from the public internet.
Private	Route traffic within an AWS VPC (not accessible publicly).
## 4. DNS Records

Common DNS records in Route 53:

Record Type	Description	Example
A	Maps a domain to an IPv4 address	example.com → 192.168.1.1
AAAA	Maps to an IPv6 address	example.com → 2001:db8::1
CNAME	Alias to another domain	www.example.com → example.com
MX	Mail server records	example.com → mail.example.com
TXT	Text records, e.g., SPF for email validation	example.com → "v=spf1 include:_spf.google.com ~all"
NS	Name servers for your domain	Automatically created for hosted zones
Alias	AWS-specific; points to AWS resources (like CloudFront or ELB)	example.com → my-load-balancer.amazonaws.com
## 5. Routing Policies

Route 53 allows different traffic routing strategies:

Policy	Use Case
Simple	Single resource, basic mapping
Weighted	Distribute traffic based on weight between multiple resources
Latency-Based	Route traffic to the region with lowest latency
Failover	Automatically route to a healthy resource if the primary fails
Geolocation	Route traffic based on user location
Multi-Value Answer	Return multiple IPs, similar to round-robin
## 6. Health Checks & Failover

Health Check: Monitors the health of endpoints (HTTP, HTTPS, TCP)

Failover Routing: Combine with health checks to redirect traffic if a resource is down

Example: If PrimaryEC2 fails, Route 53 routes traffic to SecondaryEC2.

## 7. Domain Registration

Route 53 can register new domains or transfer existing ones.

Supports .com, .net, .org, .in, etc.

Automatic DNS configuration after registration

Can integrate with SSL/TLS certificates (ACM) for HTTPS

## 8. Integration with Other AWS Services
AWS Service	Integration with Route 53
EC2	Route traffic to EC2 instances
S3	Host static websites with Alias records
CloudFront	Map domains to CDN endpoints using Alias
ELB / ALB	Alias record points to load balancer
API Gateway	Route domain traffic to API endpoints
## 9. Hands-On Lab: Step-by-Step

Goal: Create a domain, host zone, and point it to an EC2 instance.

Step 1: Register Domain

Open Route 53 → Domains → Register Domain

Choose domain mydemo.com → Complete registration

Step 2: Create Hosted Zone

Route 53 → Hosted Zones → Create Hosted Zone

Enter domain name → Select Public

Step 3: Create DNS Record

Click Create Record

Choose type A

Enter EC2 Public IP → Save

Step 4: Test Domain

Open browser → http://mydemo.com should show EC2 website

Step 5: Optional – Setup Failover

Add another EC2 instance

Create health checks

Use Failover routing policy to switch automatically if primary fails

## 10. Best Practices

Use Alias records for AWS resources instead of CNAME for better performance.

Enable health checks for critical resources.

Use TTL (Time to Live) wisely; shorter TTL for dynamic endpoints.

Split environments using Private Hosted Zones in VPC.

Enable DNSSEC for domain security (optional but recommended).