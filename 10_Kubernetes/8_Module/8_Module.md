### Secure cluster and workloads.

### Topics


## RBAC
	- RBAC stands for Role-Based Access Control. It’s a method to regulate who can do what inside a Kubernetes cluster.       Essentially, it controls permissions for users, groups, and service accounts.
	- RBAC decides who can access which resources and what actions they can perform on those resources.
	
	WHY !!!
	
	- Secures your cluster: Only authorized users can modify resources.
	- Enforces the principle of least privilege: Users only get the access they need.
	- Required for multi-user clusters or production environments.
	
	
### Key Components of RBAC

### Role
	
	Defines a set of permissions within a namespace.
	Example: read pods, create deployments.
	
		```bash	
		
			apiVersion: rbac.authorization.k8s.io/v1
		kind: Role
		metadata:
		namespace: dev
		name: pod-reader
		rules:
		- apiGroups: [""]
		resources: ["pods"]
		verbs: ["get", "watch", "list"]
		
		```
###	ClusterRole

	Similar to Role, but cluster-wide (can access resources across all namespaces).
	Example: view all nodes, manage cluster-level resources.

##	RoleBinding

	A RoleBinding binds a Role to a user, group, or service account, giving them the permissions defined in that Role and but only within the specified namespace (dev ,staging, pre-prod)
	
	Links a Role → Subject (user/group/service account).
	
			```bash
			
			apiVersion: rbac.authorization.k8s.io/v1
		kind: RoleBinding
		metadata:
		name: read-pods
		namespace: dev
		subjects:
		- kind: User
		name: alice
		apiGroup: rbac.authorization.k8s.io
		roleRef:
		kind: Role
		name: pod-reader
		apiGroup: rbac.authorization.k8s.io
		
			
			```

##	ClusterRoleBinding

	Assigns a ClusterRole cluster-wide , or Binds that ClusterRole to a subject (user, group, or service account).
	Links ClusterRole → Subject globally.
	
	```bash
	
			apiVersion: rbac.authorization.k8s.io/v1
		kind: ClusterRole
		metadata:
		name: cluster-admin
		rules:
		- apiGroups: ["*"]
		resources: ["*"]
		verbs: ["*"]
	
	```


### Service Accounts
	Every Pod in Kubernetes runs as some identity, and that identity is a ServiceAccount.

Examples:

	- Ingress controllers (like NGINX ingress) use a ServiceAccount to watch Ingress objects.
	- CI/CD pipelines running inside Kubernetes (like Jenkins agents) use ServiceAccounts to deploy apps.
	- Operators (like Prometheus Operator or ArgoCD) use ServiceAccounts to create/update resources automatically.
	- Without a ServiceAccount, a Pod can’t talk to the Kubernetes API safely.


### Pod Security Standards
	Pod Security Standards ensure that pods run safely and predictably, protecting the cluster from privilege escalation or unsafe access. Baseline is typical for dev/test, and Restricted is used for production security.
	
		- Prevents unsafe pod behaviors (like running as root or accessing host resources).
		- Protects clusters from accidental or malicious privilege escalation.
		- Ensures compliance with security best practices.
		
		Three Levels of PSS:
		
			1)Privileged – Almost no restrictions; pods can run as root, mount host paths, and use host networking. Usually used only for system workloads.

			2)Baseline – Safe defaults for typical applications; allows most workloads to run safely with minimal risk. Commonly applied to development or testing namespaces.

			3)Restricted – Strictest level; pods cannot run as root, have minimal capabilities, and cannot access host resources.Recommended for production or high-security environments.
	
	
			How to apply : 
	
			```bash
		
			kubectl label ns dev pod-security.kubernetes.io/enforce=baseline
			kubectl label ns prod pod-security.kubernetes.io/enforce=restricted
	
			```
	
### Secrets encryption basics


### Network Policies (Introduction)