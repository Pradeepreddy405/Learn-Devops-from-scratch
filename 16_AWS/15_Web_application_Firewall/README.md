# 1) AWS Web Application Firewall
1) AWS WAF (Web Application Firewall) is a Layer-7 (HTTP/HTTPS) firewall service that protects web applications by inspecting incoming web requests and allowing, blocking, or monitoring traffic based on rules.
2) It protects against the SQL injection, Cross-site scripting (XSS), Bad bots, HTTP floods, Excessive requests, Malicious patterns in requests
	
	## Rule Evaluation 
	1) AWS WAF evaluates incoming web requests based on the priority order of rules defined inside a Web ACL. Each rule is assigned a priority number, and AWS WAF 		processes the rules from the lowest number to the highest.
	
	2) When a request matches a rule condition, AWS WAF immediately applies the configured action (such as ALLOW, BLOCK, COUNT, CAPTCHA, or CHALLENGE) and stops 		evaluating any remaining rules. This behavior is known as first match wins.

	3) If a request does not match any rules in the Web ACL, AWS WAF applies the default action, which is configured at the Web ACL level (typically ALLOW or 			BLOCK).

	## WAF does NOT sit directly on EC2 but it protects traffic at the edge or load balancer layer.
	AWS WAF can be attached to:
		Amazon CloudFront
		Application Load Balancer (ALB)
		API Gateway
		AWS App Runner
		AWS Cognito
		
# 2) Key component of WAF is Web ACL 
Web ACL (Access Control List) - A Web ACL contains rules that inspect requests. We define the rules then the action will be ALLOW,BLOCK,COUNT ,CAPTCHA CHALLENGE

# 3) Common rules 
   ## Rate Limiting
		Rate limiting is used to  protect the application from too many requrests comming from same ip address 
		create a rule that only allow less pre defined requests with in a specific window time .if execeed more than defined 
		requests block the ip
   ## Geo blocking 
		Block traffic from specific countries.
		
		Note : VPN can by pass this rule. It better use this rule with combined managed rules and rate limiting rule to prevent unwanted regional traffic
   ## Managed Rules
		AWS provides ready made security rules. No need to write custom logic . we simply use the  existed rules from SQL injection protection, XSS protection
		
# 4) WAF Sheild
AWS Shield is a managed DDoS protection service from AWS. Its job is to protect your AWS applications from Distributed Denial of Service (DDoS) attacks, attacks where attackers send huge amounts of traffic to crash or slow down a system.

   ## Without protection
	Attack traffic → ALB / CloudFront → Server overload → Application down

   ## With Shield
	Attack traffic → AWS Shield absorbs attack → App stays available

# 5) work flow WAF + Shield

		Internet
			↓
		CloudFront
			↓
		AWS Shield (automatic)
			↓
		AWS WAF (rules & filtering)
			↓
		Application Load Balancer
			↓
		EC2 / Containers
		
# 6) Security big pitcure

		Internet
			↓
		AWS Shield    	 	----> DDoS protection (L3/L4)
			↓
		AWS WAF      		----> HTTP filtering (L7)
			↓
		ALB / CloudFront
			↓
		Security Group 		----> Instance firewall
			↓
		NACL           		----> Subnet firewall
			↓
		EC2 / ECS / App
		
		


# 7) Summary 

1) AWS WAF provides Layer-7 protection attached to CloudFront/ALB/API Gateway. Requests are inspected against Web ACL rules including managed rules, rate limits, geo restrictions and custom regex patterns. 

2) AWS Shield is a managed DDoS protection service that automatically protects AWS resources like CloudFront, Route 53 and ALB from network and transport layer attacks. Shield Standard is enabled by default, while Shield Advanced provides enhanced detection and response capabilities.

3) In production based architectures, WAF is combined with AWS Shield, logging pipelines, and monitoring to stop attacks at the edge and reduce backend load.
