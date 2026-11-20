### 1)	What is Kubernetes?
Kubernetes is an open-source container orchestration platform that automates deployment, scaling, self-healing, and lifecycle management of containerized applications, ensuring high availability across distributed infrastructure.
		

			
###	2) 	Why	Container Orchestration needed ?
As companies began moving from monolithic applications to microservices, they started running hundreds or thousands of containers. Running all of them manually quickly became impossible, Mostly when running containers in production especially when demand Fluctuated at that point of time they faced below mentioned problems


   1) Manual scaling:
   		- If traffic increased, someone had to manually start more containers
   		- When traffic dropped, unused containers wasted resources
   		- Slow and not real-time
   
   2) No automated load balancing
   		- Containers had to be manually connected to load balancers
   		- If a container died, traffic still went to it
   
   3) Lack of self-healing		
   		- Failed containers stayed down
   		- Engineers had to restart them manually
   		- High downtime risk
   
   4) Configuration drift
   		- Different containers could run different configurations
   		- Hard to maintain consistency across multiple environments
   	
   5) Manual container placement
   		- You had to choose which server (node) each container ran on
   		- Could overload one node and underuse others
   
   6) Difficulty managing microservices
   		- With tens or hundreds of services:
   		- Tracking IPs and ports was painful
   		- Service-to-service communication was unreliable
   		- Hard to manage version updates or rollbacks
   
   7) No rolling updates
   		- Updates often caused downtime
   		- Could not gradually roll out new versions
  	 	- No automated rollback if something failed
   
   8) If container crash or goes down, the application inside a container also goes down or unable to access that application 
   	- Containers made deployment easier—but managing thousands of containers made operations harder.
   
   9) Single server dependency
	- Single server dependency means the entire application relies on one server, so if that server fails, a single point of failure occurs and the whole application goes down.

### Orchestration platforms automated the whole lifecycle:
			- deployment
			- scaling
			- load balancing
			- monitoring
			- self-healing
			- upgrades
			- This is why Kubernetes apart form all orchetration platforms kubernetes became essential for modern production  systems for its features.

---			
	
 ###  Challenges solved by kubernetes
	
	1) Automation :		
		- Automatically deploy, restart, scale, and manage containers
		- Reduce manual intervention for routine tasks
			
	2) High availability :
		- Keep applications running even if containers or nodes fail
		- Automatically restart or replace failed containers
			
	3) Scalability :
		- Automatically scale apps up/down as traffic changes
		- Efficiently use cluster resources
		
	4) Efficiency in production :
		- Schedule containers optimally across cluster nodes
		- Use CPU, memory, and storage effectively
			
	5) Consistency :
		- Ensure applications run the same way across environments
		- Avoid “it works on my machine” problems
			
	6) Single server dependency is dangerous because one failure brings everything down. 
		- Kubernetes removes this risk by running your app across multiple servers with automatic recovery.	
	
---	
### Orchestration Summary : 
   - Containers made deployment easier—but managing thousands of containers made operations harder.		
   - Kubernetes is an open-source container orchestration platform that runs, manages, scales, and heals containerized applications automatically.
	
   #### Problems solved by kubernetes :
	1) Auto scaling	: Kubernetes uses Horizontal Pod Autoscaler (HPA) to automatically scale Pods based on metrics such as CPU or memory usage.
	2) Load balancing: Kubernetes Services provide stable network endpoints and automatically distribute incoming traffic across multiple Pods.
	3) Auto healing	: Kubernetes continuously monitors application health and automatically restarts or replaces failed containers and Pods to maintain the                              desired state.
	4) Host failure	: Kubernetes detects unhealthy nodes and reschedules Pods to healthy nodes, ensuring high availability even when a host fails.
		
	
	
	
###	3)	Kubernetes architecture  
Kubernetes is inherently a clustered system. Even the smallest Kubernetes setup is logically a cluster consisting of a control plane and one or more worker nodes.
		
- Cluster = Control plane + Worker node(s)
			
	- Cluster components :

   		   Control Plane  
					- API Server  
					- Scheduler  
					- Controller Manager  
					- etcd  
			Data Nodes  
					- kubelet  
					- kube-proxy  
					- Container Runtime
		
### <h2>Kubernetes Architecture</h2>
   <img src="Images/00_Kubernetes_Architecture_001.png" width="800">
