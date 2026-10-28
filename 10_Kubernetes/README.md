# Kubernetes Complete Learning Path

	A structured, hands-on roadmap to learn Kubernetes from **fundamentals to production-level skills**.

---

## Module 1: Kubernetes Fundamentals
Understand why Kubernetes exists and the problems it solves.

### Topics
	- What is Kubernetes? Why it evolved
	- Kubernetes architecture  
		- Control Plane  
			- API Server  
			- Scheduler  
			- Controller Manager  
			- etcd  
		- Worker Nodes  
			- kubelet  
			- kube-proxy  
			- Container Runtime
	- Cluster concepts
	- Kubernetes vs Docker Swarm

  ### Hands-on
   - Install `kubectl`
   - Setup Minikube / Kind
   - Verify cluster:
						```bash
						kubectl version
						kubectl get nodes
						kubectl cluster-info
						```
						
---

## Module 2: Kubernetes Core Objects
Learn the fundamental building blocks.
	
	### Topics
	- Pods
	- ReplicaSets
	- Deployments
	- Namespaces
	- Labels & Selectors
	
### Hands-on
   - Create a Pod using YAML
   - Create a Deployment
   - Scale replicas
   - Delete and recreate Pods
   - Explore namespaces
		
---

## Module 3: Kubernetes Services & Networking
Understand how Pods communicate internally and externally.

	### Topics
	- Why Services are needed
	- Service types:
	- ClusterIP
	- NodePort
	- LoadBalancer
	- kube-proxy basics
	- Pod-to-Pod communication
	- DNS in Kubernetes
	
		### Hands-on
		- Expose a Deployment:
		```bash
		kubectl expose
		```
		- Create NodePort service
		- Test service discovery
		- Access application from browser
		
		---

## Module 4: Configuration Management
Manage configuration without rebuilding images.

	### Topics
	- ConfigMaps
	- Secrets
	- Environment variables
	- Config files in Pods
	
		### Hands-on
		- Create ConfigMap from files and literals
		- Create Secrets
		- Inject configuration into Pods
		- Verify sensitive data handling
		---

## Module 5: Storage & Persistent Volumes
Handle stateful applications.

	### Topics
	- Volumes vs Persistent Volumes
	- PersistentVolume (PV)
	- PersistentVolumeClaim (PVC)
	- Storage Classes
	- StatefulSets (Introduction)
	
		### Hands-on
		- Create PV and PVC
		- Deploy MySQL/PostgreSQL with persistence
		- Verify data survives Pod restart
		
		---

## Module 6: Scheduling & Resource Management
Control where and how workloads run.

	### Topics
	- Resource requests & limits
	- QoS classes
	- Node selectors
	- Taints & tolerations
	- Affinity & anti-affinity
	
		### Hands-on
		- Set CPU and memory limits
		- Force Pod scheduling on specific nodes
		- Test resource throttling
		
		---

## Module 7: Application Lifecycle Management
Manage application updates safely.

	### Topics
	- Rolling updates
	- Rollbacks
	- Deployment strategies
	- Health checks:
	- Liveness probes
	- Readiness probes
	- Startup probes

		### Hands-on
		- Perform rolling update
		- Rollback to previous version
		- Configure probes
		- Simulate failure recovery
		
		---

## Module 8: Kubernetes Security
Secure cluster and workloads.
	
	### Topics
	- RBAC  
	- Roles  
	- RoleBindings  
	- ClusterRoles
	- Service Accounts
	- Pod Security Standards
	- Secrets encryption basics
	- Network Policies (Introduction)

		### Hands-on
		- Create Role and RoleBinding
		- Restrict namespace access
		- Use ServiceAccounts in Pods
		
		---

## Module 9: Advanced Kubernetes Concepts
Gain production-grade Kubernetes understanding.

	### Topics
	- Ingress & Ingress Controllers
	- Horizontal Pod Autoscaler (HPA)
	- Vertical Pod Autoscaler (Introduction)
	- Jobs & CronJobs
	- DaemonSets

		### Hands-on
		- Configure NGINX Ingress
		- Setup HPA with metrics-server
		- Run CronJobs
		- Deploy DaemonSet
		
		---

## Module 10: Kubernetes & CI/CD
Automate Kubernetes deployments.
	
	### Topics
	- CI/CD with Kubernetes
	- GitHub Actions / GitLab CI
	- Image tagging strategies
	- Rolling deployments via CI

		### Hands-on
		- Build image and push to registry
		- Deploy via CI pipeline
		- Auto-update Kubernetes deployments
		
		---

## Module 11: Kubernetes on Cloud
Run Kubernetes in real cloud environments.

	### Topics
	- Kubernetes on AWS (EKS)
	- GKE / AKS overview
	- Managed vs self-managed clusters
	- LoadBalancers & IAM integration
	
		### Hands-on
		- Deploy application on EKS
		- Connect `kubectl` to cloud cluster
		- Expose service using LoadBalancer
		
		---

## Module 12: Monitoring, Logging & Troubleshooting
Operate Kubernetes in production.

### Topics
- kubectl debugging commands
- Logs & events
- Prometheus & Grafana
- EFK / ECK stack
- Common failure scenarios

		### Hands-on
		- Debug crashing Pods
		- Setup basic monitoring
		- Analyze logs and metrics
		
		---

## Module 13: Kubernetes Projects & Portfolio


### Project Ideas
	1. **Three-tier Application on Kubernetes**  
	Frontend + Backend + Database with persistence
	
	2. **CI/CD Pipeline with Kubernetes**  
	GitHub Actions → Docker → Kubernetes deployment
	
	3. **Auto-scaling Application**  
	HPA with load testing
	
	4. **Secure Multi-Namespace Setup**  
	RBAC + Network Policies
	
	5. **Cloud Kubernetes Deployment**  
	EKS + Ingress + TLS
	
-----

