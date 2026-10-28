### 1)	What is Kubernetes Orchestration?

Kubernetes orchestration is how Kubernetes automatically deploys, schedules, scales, heals, and manages containerized applications across a cluster of machines (nodes).

---
### 2) Kubernetes Architecture
Cluster    : A Kubernetes cluster is a collection of control plane and worker nodes that work together to deploy, manage, scale, and heal containerized 
			 applications.
				 
Cluster consists of two important components i.e nothing but (Control plane)Master node and (Data plane)worker nodes.
			   
				 	Cluster =  Control plane + worker  nodes 
					
			    	1) Control plane components (API Server , Scheduler , Control manager and etcd(cluster state database) . 
					2) Worker node components   (Kubelet, proxy, CNI (Networking),Container run time
	
<img src="Images/00_Kubernetes_Architecture_002.png" width="700"/>

---
### 3) Control plane components:

   ### 3.1)  API Server
   
   The API Server is the central management component of Kubernetes. It acts as the front door to the cluster, handling authentication, authorization, 		      validation, admission control, and storing the desired state in etcd. All control plane and worker components communicate through the API Server.
			
			- Receives all requests (kubectl, UI, CI/CD)
			- Validates YAML
			- Authenticates & authorizes
			- Stores desired state in etcd
			- Nothing in Kubernetes happens without the API Server

   ###  3.2) etcd (Memory of the Cluster)

   etcd is a distributed, strongly consistent key-value store that acts as the single source of truth for Kubernetes. It stores all cluster state, configuration,     and metadata. The API Server is the only component that interacts with etcd, ensuring secure, consistent, and reliable storage of the cluster’s desired and        current state.

			Stores:
				- Desired state (replicas, images, configs)
			 	- Actual cluster metadata
				- Acts as single source of truth
	
			Example:
			
				- Desired replicas = 3
				- Controller Manager (Reconciliation Engine)
				
				- Continuously checks:
				- Desired state (etcd) VS Actual state (nodes)
			
				- If mismatch:
				- Takes corrective action like to scale up or scale down pods
			
					Example:
					
						Desired Pods = 3
						Running Pods = 2
						Controller creates 1 new Pod

   ### 3.3)Scheduler:

   Kubernetes Scheduler selects the most suitable node for a Pod based on resource availability, constraints, and policies, then binds the Pod to that node.
		
			- Picks which worker node should run the Pod
			- Considers:
				CPU & memory availability
				Node labels / taints
			- Caution:
				Scheduler does not run Pods
				It only assigns Pods to nodes
   ### 3.4) Controller-manager
		
   Kube-controller-manager continuously reconciles the desired state with the actual state of the cluster by running multiple controllers like node, replica,         deployment, and endpoint controllers.

		- Maintains correct number of Pods
		 	 	If a Pod crashes → creates a new one
		- Monitors node health
				If a node becomes NotReady → reschedules Pods
		- Handles Deployments & ReplicaSets
		   		Rolling updates
				Rollbacks
				Scaling
		- Manages Services & Endpoints
			 	Updates which Pods receive traffic
		- Cleans up resources 
				Deletes all objects when a namespace is deleted
	

### Data plane (Worker node) components:

   ### 3.5) kubelet: Pod lifecycle manager
   
   kubelet is a node-level agent that ensures containers described in Pod specs are running and healthy on a node.
		
		- Talks to the API Server
		- Creates, starts, stops Pods on the node
		- Ensures containers match the desired state
		- Performs health checks (liveness/readiness probes)
		- Reports node & pod status back to control plane	
			
		
   ### 3.6) kube-proxy: Networking & traffic manager (per node)
   
   kube-proxy maintains Service networking and load-balancing rules on nodes, leveraging the Pod network provided by CNI plugins
   
			- Implements Services (ClusterIP / NodePort / LoadBalancer)
			- Handles network traffic routing to Pods
			- Uses iptables / IPVS rules
			- Load-balances traffic across healthy Pods
			
   ### 3.7) Container Runtime(containerd,CRI-O,Docker) : with run time applications will run inside the pods
   
   The container runtime is responsible for pulling images and running containers on worker nodes, as instructed by kubelet via the CRI.
   
			- Responsible for running containers
			- Pulls container images from registries
			- Creates and starts containers inside Pods
			- Stops and deletes containers when required
			- Works with kubelet via CRI (Container Runtime Interface)

   ### 3.8) CNI (Container Network Interface) — Pod networking provider

   CNI plugins provide Pod networking by assigning IPs and enabling communication between Pods across the cluster.
   
			- Calico
			- Flannel
			- Cilium
			- Assigns IP addresses to Pods
			- Enables Pod-to-Pod communication
			- Enables Pod-to-Service communication
			- Handles cross-node networking
			- Enforces Network Policies (if supported)
			
=========================================================================================================================================================		
### Summary :
   Kubernetes Orchestration is automated process of maintaining the desired state of containerized applications by cordinating with control plane decissions
   and worked node execution across a cluster.
		
- API Server					:Acts as the central entry point of the cluster, handling all requests and communication between components.
- Scheduler					:Assigns newly created Pods to suitable worker nodes based on resource availability and constraints.
- Controller Manager				:Continuously monitors the cluster and ensures the actual state matches the desired state.
- etcd						:A distributed key-value store that permanently stores the cluster’s configuration and state.
- kubelet					:An agent that runs on each worker node and ensures Pods are running as instructed by the control plane.
- Container Runtime (Docker / containerd)	:Responsible for pulling images and creating, starting, and stopping containers.
- CNI (Container Network Interface)		:Provides networking for Pods, enabling pod-to-pod and pod-to-service communication.
- kube-proxy					:Manages network rules on the node to route traffic to the correct Pods and Services.
