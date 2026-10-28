### Module 6: Docker Registry & Images
---

### 1) Docker Registry

   1) A Docker Registry is a centralized, versioned storage system for Docker images, used to push, pull, secure, distribute,   and manage container images across     environments like dev, QA, staging, and production.
   2) It acts as the single source of truth for container artifacts in a CI/CD pipeline.

		Types of Docker Registries
			> Public Registry
			 	- Docker Hub (public repos)
			> Private Registry (Enterprise Use)	
				- AWS ECR
				- Azure ACR
				- Google Artifact Registry
				- Self-hosted Docker Registry	
	3) Registry vs Repository
		
		1)Registry : A registry is a centralized service that hosts container images and makes them available for push and pull operations. 
		
		2)Repository : A repository is a logical grouping of related images (same application) inside a registry.	
			- Multiple image versions (tags)
			- Same app, different builds
			- Different environments
					
---	

### 2) Docker Hub: Pulling and pushing images

Docker Hub is a cloud-hosted container registry service provided by Docker, used to store, manage, share, and distribute container images.

Private registries
	A private registry is a container registry that restricts access so only authorized users, services, or systems can push or pull container images. Unlike 	 		public registries, images are not publicly accessible.

Example : Amazon Elastic Container Registry ,Google Artifact Registry , Azure Container Registry   ---> private Registries
	
Docker hub ----> Public Registry

---

### 3) Tagging images for different environments
   - Tagging is how you identify the same Docker image for different environments like dev, test, staging, prod.
   - A tag is just a label
		1) Environment-based tags
			- dev
			- test
			- staging
			- prod		
			Example: 	mrcloud111/frontend:dev
						mrcloud111/backend:prod					
		2) Version-based tags (recommended)
			- v1.0
			- v1.1
			- v2.0
			Example: mrcloud111/front_end:v1.0
				 mrcloud111/back_end:v1.0				 
		3) Combined tags (Environment with version )
			- v1.0-dev
			- v1.0-staging
			- v1.0-prod	
			Example : mrcloud111/frontend:v1.0-prod
		Why tagging ?
			- Deploy the same app to multiple environments
			- Roll back easily
			- Track versions clearly
			- CI/CD friendly
		
	
---  

### Hands-on:
  - Push your custom image to Docker Hub
  - Pull the image on another machine
  - Explore AWS ECR
