### Deployment workflow
---
### Step 1: Write the deployment.yaml

	- You define the desired state in deployment.yaml file
	- Number of pods (replicas)
	- Container image (nginx:latest)
	- Ports, labels, environment variables, volumes, etc.


### Step 2: Apply the deployment

	Command: kubectl apply -f deployment.yaml

	What happens:
		- kubectl sends the Deployment manifest to the API Server.
		- API Server validates, parses, and stores it in etcd (the cluster’s key-value store).
		- Declarative approach: You only tell Kubernetes what you want, not how to do it.
		
	Components involved: kubectl → API Server → etcd.

### Step 3: Deployment Controller takes over

		- The Deployment Controller in Controller Manager watches the Deployment object in API Server.
		- It compares desired replicas with current pods.
		- It updates the ReplicaSet accordingly:
		- If pods are missing → increase spec.replicas
		- If too many pods → decrease spec.replicas

	Components involved: Deployment Controller, API Server, ReplicaSet object.

### Step 4: ReplicaSet creates Pods

		- The ReplicaSet Controller (also in Controller Manager) sees changes in the ReplicaSet object.
		- It ensures correct number of pods exist:
		- Creates Pod objects via API Server if needed.
		- Deletes excess pods if needed.
		- Each Pod is created from the pod template specified in the Deployment.

	Components involved: ReplicaSet Controller, API Server.

### Step 5: Scheduler assigns pods

		- Newly created Pods are in Pending state.
		- Scheduler picks an appropriate node based on:
		- Resource availability
		- Node selectors/affinities
		- Kubelet on the node pulls the container image and starts the container.
		
	Components involved: Scheduler, Kubelet, container runtime (Docker/containerd).

### Step 6: Pod becomes Ready
	
		Kubernetes monitors pods via readiness/liveness probes (if defined).
		Once all containers in the pod are running and ready → pod is marked Ready.
	Components involved: Kubelet, API Server (updates pod status), optionally health probes.

### Step 7: Expose the Deployment

		- You can expose pods via a Service:
		- kubectl expose deployment nginx-deployment --type=NodePort --port=80
		- Service provides a stable endpoint (ClusterIP/DNS/IP) that abstracts pod IPs.
		
	Components involved: API Server (stores Service object), kube-proxy, networking layer.

### Step 8: Kubernetes maintains desired state

	Kubernetes constantly reconciles:
		- If a pod dies → ReplicaSet recreates it automatically.
		- If Deployment replicas change → Deployment controller updates ReplicaSet.
		- If Deployment image updates → Deployment performs rolling updates one pod at a time.
		- This is the self-healing loop of Kubernetes.
		
	Components involved: Deployment Controller, ReplicaSet Controller, API Server, Scheduler, Kubelet.
---
### Summary :

	Deployment → ReplicaSet → Pods is the control hierarchy.
	Controllers (Deployment, ReplicaSet) live in the Controller Manager on control plane nodes.
	Scheduler assigns pods to nodes.
	Kubelet + container runtime actually runs containers.
	API Server is the central hub — every controller talks to it, never directly to etcd.
