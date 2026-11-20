#1 Security Groups
Security Groups (SGs) are stateful, virtual firewalls attached to AWS resources (most commonly EC2, but also ALB/NLB, RDS, Lambda in VPC, ENIs). They control who can talk to your resource and on which ports/protocols.

	## Core components 
	Stateful 			: If inbound traffic is allowed, return traffic is automatically allowed, no need for outbound rules.
	Allow rules only 	: No explicit deny. Anything not allowed is implicitly denied.
	Resource-level 		: Attached to EC2/ENI, not to subnets.
	Evaluated before NACLs (effectively) : Traffic must pass both SG and NACL, but SGs are more commonly used.
	
	## Inbound vs Outbound
	
	### Inbound rules → who can reach the resource
		Example: Allow TCP 22 from Bastion SG

	### Outbound rules → where the resource can go
		Default: Allow all outbound
		
#2 NACL 
A Network Access Control List (NACL) is a stateless firewall that works at the subnet level in a VPC.
It controls inbound and outbound traffic to and from one or more subnets.

	## Core components
	Stateless				: If you allow inbound traffic, you must explicitly allow outbound traffic
	Rule-based				: Rules are evaluated in order (lowest number first)
	Supports ALLOW and DENY : Unlike Security Groups, which only allow
	
	
	### Why NACL if we already have Security Groups
	
		- Block a specific IP range at subnet level
		- Add a coarse-grained firewall before traffic reaches instances
		- Meet compliance
		
		
		
		
		
		
		
		
		
		
		
Note : 	Traffic must pass NACL (subnet) first, then Security Group (instance).
		NACL is stateless, Security Group is stateful.