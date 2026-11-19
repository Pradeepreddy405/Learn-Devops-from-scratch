## 1) Load balancer 
The load balancer distributes incoming application traffic across multiple targets.
              (or)
An AWS Load Balancer (part of Elastic Load Balancing) automatically distributes incoming application traffic across multiple targets, like EC2 instances, containers, or IP addresses, to improve application availability, scalability, and reliability by preventing any single server from being overwhelmed.

## 2) Key components
- Traffic Distribution	: Spreads requests across a pool of resources, ensuring even load.
- High Availability		  : Routes traffic only to healthy targets, detecting and bypassing unhealthy ones.
- Scalability				    : Automatically scales to handle traffic spikes and reduces capacity as needed.
- Security				      : Can offload SSL/TLS encryption/decryption, allowing backend servers to focus on application logic.
- Health Checks			    : Continuously monitors target health to ensure requests go to ready servers.

## 3) Types of Load Balancers in AWS
  1) Application Load Balancer (ALB): Operates at the application layer (Layer 7), ideal for HTTP/HTTPS traffic, supports advanced routing (URL-based), and WebSockets.
  2) Network Load Balancer (NLB): Operates at the transport layer (Layer 4), handling TCP, TLS, UDP, and QUIC with extremely high performance. 
  3) Gateway Load Balancer (GLB): Operates at the network layer (Layer 3) for deploying and managing virtual network appliances.


## 4) How load balancers work
1 Clients send requests to the load balancer's DNS name.
2 A Listener (protocol/port) on the load balancer receives the request.
3 The load balancer uses rules to forward the request to a Target Group.
4 Within the Target Group, healthy Targets (EC2, containers, etc.) receive the request.
5 The load balancer performs Health Checks on targets, routing only to those responding correctly.
