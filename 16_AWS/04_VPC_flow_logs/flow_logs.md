### 1) Flow Logs : 
	VPC Flow Logs capture IP traffic metadata for inbound and outbound network traffic at the VPC, subnet, or ENI level.

### 2)What do Flow Logs record?
	Flow logs does not capture packet content, only metadata
		Source IP & Destination IP
		Source port & Destination port
		Protocol (TCP/UDP/ICMP)
		Bytes & packets transferred	
		ACCEPT or REJECT (by SG/NACL)
		Start & end time


### 3)Where can you enable flow logs ?	

	1) VPC level → all traffic in the VPC
	2) Subnet level → traffic for that subnet
	3) ENI level (Elastic Network Interface) 
		EC2, ALB, RDS , NAT Gateways, Lambda - vpc attached



### 4)Where are Flow Logs stored?

	1) CloudWatch Logs → real-time monitoring & alerts
	2) S3 → long-term storage, Athena queries
	3) Kinesis Data Firehose → analytics pipelines


