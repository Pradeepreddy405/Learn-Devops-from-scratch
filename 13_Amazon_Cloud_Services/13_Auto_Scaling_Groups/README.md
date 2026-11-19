# Scaling 
1) Scaling is the process of increasing or decreasing resource capacity to match application demand.
2) In cloud environments like AWS, scaling ensures your application has enough CPU, memory, storage, or instances to handle traffic efficiently — without overprovisioning.

	## Types of scaling	
		1) Vetical scaling  
			Vertical scaling in AWS (also called “scaling up”) means increasing the capacity of a single resource to handle higher workloads. For example, upgrading an Amazon EC2 instance from t3.medium to t3.2xlarge provides more CPU, memory, and network performance to support increased demand.
			
		2) Horizontal scaling
			Horizontal scaling means increasing application capacity by adding more servers (instances) instead of making a single server more powerful.
		
	In AWS, this is typically done by launching multiple Amazon EC2 instances and distributing traffic across them using Elastic Load Balancing (ALB/NLB),Amazon EC2 Auto Scaling

## ASG Supports Horizontal Scaling
Auto Scaling Groups support horizontal scaling by automatically adding or removing EC2 instances based on demand. They do not perform vertical scaling.

## Auto scaling groups

Amazon EC2 Auto Scaling groups (ASGs) are a core AWS feature that automatically adjust the number of Amazon EC2 instances to match demand, ensuring high application availability and cost optimization. They maintain a MINIMUM, MAXIMUM, and DESIRED capacity, replacing unhealthy instances to keep applications running seamlessly.

### Key Aspects

	1) Dynamic Scaling: Automatically launches or terminates EC2 instances in response to real-time traffic, CPU load, or scheduled events.
	2) High Availability & Health Checks: The ASG detects unhealthy instances and automatically replaces them to ensure consistent performance.
	3) Cost Optimization: Reduces costs by scaling down during low-demand periods and scaling up only when necessary.
	4) Components: An ASG consists of a 
		- launch template defines instance (type, AMI, key pair ) and WHAT TO SCALE
	    - scaling policies defines 	WHEN TO SCALE
		- ASG defines WHERE TO LAUNCH

### Benefits:
	High Availability 	: Deploys across Multi-AZ and replaces unhealthy instances automatically.
	Elasticity			: Handles unpredictable traffic spikes automatically.
	Cost Optimization 	: Prevents over-provisioning by scaling in during low traffic.
	Fault Tolerance		: Automatically replaces failed EC2 instances.
	Self healling		: Automatically detecting unhealthy EC2 instances and replacing them without manual intervention.

### Types of scaling policies
	1) Target Tracking Scaling
		Maintain CPU at 50%
		Automatically adjusts
	
	2) Step Scaling
		Different scaling actions based on alarm thresholds
	
	3) Scheduled Scaling
		Scale at fixed time (e.g., 9 AM daily)
	
	4) Predictive Scaling
		Uses ML to forecast traffic	
		
### Use cases
	1) Web Applications: Handling fluctuating user traffic throughout the day.
	2) Batch Processing: Scaling resources up for heavy, short-term, or scheduled workloads.
	3) Fault-Tolerant Architectures: Ensuring applications stay online by replacing failed nodes. 
	


### Work flow

User → ALB → Target Group → Auto Scaling Group → EC2 instances (Multi-AZ)


### Step-by-step Flow:

		Users send traffic
			|
		Traffic hits Application Load Balancer (ALB)
			|
		ALB distributes traffic to EC2 instances
			|
		CloudWatch monitors CPU/metrics
			|
		ASG increases or decreases instances automatically