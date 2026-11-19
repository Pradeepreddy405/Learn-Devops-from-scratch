### Transit Gateway 
AWS Transit Gateway (TGW) is a regional networking service that acts as a central hub to connect multiple VPCs, on-premises networks (VPN/Direct Connect), and other AWS networks.

It solves the problem of complex VPC-to-VPC peering by enabling transitive routing using a hub-and-spoke model.


### Why Transit Gateway is needed
#### Without TGW

	1)VPC Peering is one-to-one
	2)No transitive routing
	3)Too many peering connections
	4)Hard to manage routing at scale

### With TGW

	1)Each VPC connects once to TGW
	2)TGW handles routing between them
	3)Centralized, scalable design
	
### work flow	
EC2 (VPC A) → VPC Route Table → Transit Gateway → TGW Route Table → VPC B → EC2
	
	
### Cost
	- TGW hourly cost
	- Data processed through TGW (per GB)
	
### Use cases

1. Multi-VPC architecture

	- Connect 10–100 VPCs easily
	- One TGW instead of many peering links

2. Hybrid connectivity
	
	- On-prem → VPN/DX → TGW → multiple VPCs
	- No need separate VPN per VPC

3. Shared services VPC

	- Central VPC for AD, logging, monitoring
	- Other VPCs access via TGW
	
### Security responsibility

	- TGW does NOT filter traffic
	- Security is enforced using:
	- Security Groups (instance level)
	- NACLs (subnet level)
	- TGW only routes, not inspects
	
	
### Summary :

### Why transit gateway 
Transit Gateway is needed to simplify large-scale VPC networking.
It acts as a central routing hub that connects multiple VPCs and on-premises networks using transitive routing.

### Difference between vpc peering and transit gateway
With VPC peering, each VPC must be directly connected to every other VPC, which creates routing complexity and does not scale.
Transit Gateway solves this by using a hub-and-spoke model, making the architecture cleaner, easier to manage, and scalable.