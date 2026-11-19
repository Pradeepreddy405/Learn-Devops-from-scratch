# Amazon Route 53
Amazon Route 53 is a highly available and scalable DNS web service that provides domain registration, authoritative DNS management, health checking, and intelligent traffic routing.

	It supports multiple routing policies such as:
		- Simple routing
		- Weighted routing (traffic splitting)
		- Latency-based routing (lowest latency region)
		- Failover routing (DR strategy)
		- Geolocation routing
		- Multi-value answer routing

	Route 53 integrates with AWS resources like ALB, CloudFront, EC2, S3 static websites, enabling high availability architectures.

	Health checks combined with failover routing allow automatic traffic redirection if an endpoint becomes unhealthy, improving resiliency and uptime.


# workflow
workflow : User → Route 53 → CloudFront → ALB → Auto Scaling EC2