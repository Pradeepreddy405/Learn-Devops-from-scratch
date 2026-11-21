# 06 – Route 53 Routing Policies

Routing policies control how Amazon Route 53 responds to DNS queries. They do not directly proxy or carry the application's HTTP traffic.

Official documentation: https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html

## 1. Simple routing

Use simple routing for a straightforward record response.

Example:
- `app.example.com` resolves to one configured endpoint.
- Suitable for a basic website or a single endpoint.

Simple routing does not provide the advanced traffic-selection behavior of the other policies.

## 2. Weighted routing

Distributes DNS responses among records according to configured weights.

Example:

| Record | Weight |
|---|---:|
| Blue environment | 90 |
| Green environment | 10 |

This can support gradual DNS-based rollout or testing.

Important: weights apply to DNS responses, not guaranteed HTTP request percentages. Resolver caching, TTL, client behavior, and existing connections mean actual application traffic may differ from the configured ratio.

## 3. Latency-based routing

Routes queries to a resource in the AWS Region that Route 53 estimates will provide the lowest latency for the querying user, based on AWS latency data and configured records.

Use case:
- Application deployed in multiple AWS Regions.
- Users should be directed toward a lower-latency regional endpoint.

## 4. Failover routing

Supports active-passive DNS failover.

Example:

```text
                    Route 53
                       |
             Health evaluation
                 /         \
          Primary           Secondary
         us-east-1          us-west-2
```

When the primary is considered unhealthy according to the configured health-check/failover setup, Route 53 can return the secondary endpoint.

Failover is DNS-based. Health-check detection, DNS caching, client retry behavior, and application recovery affect the actual failover experience.

## 5. Geolocation routing

Routes based on the geographic location of the DNS query source, using configured location rules.

Use cases:
- Region-specific content or endpoints.
- Regulatory or business routing requirements.

Configure a default record for locations that do not match a more specific rule, where appropriate.

## 6. Geoproximity routing

Routes based on the geographic location of users and resources. Bias can expand or shrink the geographic area from which a resource receives queries.

Use case:
- Directing users toward nearby resources while adjusting distribution with bias.

## 7. Multivalue answer routing

Can return multiple healthy record values in response to a DNS query. It can improve DNS-level endpoint selection, but it is not a substitute for a full load balancer.

## 8. Comparison

| Policy | Main purpose | Example |
|---|---|---|
| Simple | Basic DNS response | One application endpoint |
| Weighted | Distribute DNS answers by weight | 90/10 rollout |
| Latency | Choose lower-latency Region | Multi-Region application |
| Failover | Primary/secondary DNS response | Disaster recovery |
| Geolocation | Match query geography | Country-specific endpoint |
| Geoproximity | Geographic distance and bias | Regional traffic steering |
| Multivalue answer | Return multiple healthy values | Multiple service endpoints |

## 9. Production design considerations

- Select a policy based on the business requirement.
- Configure health checks where the design requires health-aware routing.
- Understand what the health check actually tests; a TCP check is not the same as an application-level check.
- Set an appropriate TTL and plan for caching.
- Test failure behavior before relying on it for disaster recovery.
- Monitor the application and regional dependencies independently.
- Use a load balancer for application traffic distribution within an environment.

## 10. Interview scenario: Blue-Green rollout

**Question:** You have Blue and Green application environments. How could Route 53 weighted routing help with a rollout?

**Answer:** I can configure weighted records for the two endpoints, initially assigning most DNS responses to Blue and a smaller share to Green. I would validate the Green environment using application metrics, logs, and synthetic tests, then adjust the weights gradually. I would explain that DNS weights do not guarantee exact HTTP request percentages because of resolver caching and client behavior. For strict request-level traffic shifting, I would consider an application load balancer or another traffic-management layer.

## 11. Interview scenario: Regional failover

**Question:** Your primary AWS Region becomes unavailable. How can Route 53 help?

**Answer:** I can configure failover routing with a primary endpoint, a secondary endpoint, and an appropriate health-check design. When the primary is detected as unhealthy, Route 53 can return the secondary endpoint. I would also validate data replication, application readiness, health-check behavior, TTL, and recovery procedures. DNS failover alone does not create a functioning disaster recovery environment.
