# Dockerfile Guide

## 1) What is a Dockerfile and Docker images?

  A **Dockerfile** is a text file that contains a set of instructions to automatically build a Docker image. It defines how an application and its environment are   packaged, ensuring the app runs consistently across development, testing, and production.
  
  A **Docker image** is a read-only, immutable template that contains all the dependencies, libraries, environment configurations, and application code required     to run a containerized application. It is built using a Dockerfile  

  ### What a Dockerfile does:
   - Specifies the base image (OS / runtime)  
   - Installs dependencies  
   - Copies application code  
   - Configures environment variables  
   - Defines how the container starts  
  Docker processes the Dockerfile sequentially, and most instructions create **immutable filesystem layers**, while some add **metadata**.

---

## 2) Dockerfile Instructions

  | Instruction | Description 							|
  |-------------|---------------------------------------------------------------|
  | `FROM`      | Base image 							|
  | `WORKDIR`   | Working directory inside container 				|
  | `COPY`      | Copy files into image 					|
  | `ADD`       | Similar to COPY but with extra behavior (auto-extract, URLs) 	|
  | `RUN`       | Execute commands during build		 			|
  | `ENV`       | Set environment variables 					|
  | `EXPOSE`    | Document container port 					|
  | `CMD`       | Default command, can be overridden at runtime		 	|
  | `ENTRYPOINT`| Fixed command, arguments can be appended 			|

  ### Example Dockerfile:
		
			FROM node:18-alpine
			WORKDIR /app
			COPY package*.json .
			RUN npm install
			COPY . .
			EXPOSE 3000
			CMD ["npm", "start"]
			
---
		
## 3) Building and Tagging Images
  1) Building an image
	  - Docker images are built from a Dockerfile using the `docker build` command.
		
		```bash
		docker build -t Application_name:Version_1.0 .
		```

	  - `-t` : Assigns name and tag  
	  - `.`   : Build context (current directory) — the directory Docker uses to access files during image creation  
	  - Docker reads the Dockerfile **instruction by instruction**  
	  - Each instruction creates a new **immutable layer**
   - 
  2) Tagging images
	  - Tags are used for **versioning** and **release management**.
		
		```bash
		docker tag myapplication_name:Version_1.0 myrepo/myapp:latest
		```
	  - Helps differentiate dev / test / prod images  
	  - Required for pushing images to Docker Hub / ECR / GCR  
	  - Enables rollback by reusing older tags  
		
	   **Note:** Tagging is critical in CI/CD pipelines to ensure **traceability** and **reproducibility** of deployments.
		
	
---	
## 4) Understanding Layers and Caching
  ### 1) Docker Image Layers
        
		Docker images are a **stack of layers**, not a single file.
		Example Dockerfile layers:
		
		| Instruction | Layer 							|
		|-------------|---------------------------------|
		| `FROM node:18-alpine` | Base image		 	|
		| `WORKDIR /app`        | WORKDIR 				|
		| `COPY package.json .` | Copy dependencies 	|
		| `RUN npm install`     | Install dependencies 	|
		| `COPY . .`            | Copy source code 		|
	
  - Layers are **immutable**, **cached**, and **shared** across images.
	
  ### 2) Docker Build Cache
    - Docker build cache is a **layer reuse mechanism**.
    - During `docker build`:
    - Docker checks each instruction
    - If instruction and context haven’t changed, Docker **reuses the cached layer**
    - Cache is invalidated if either the instruction OR the files used by that instruction change
	
	**Example:**
		**First build**
    
			```
			FROM → cached
			COPY package.json → new
			RUN npm install → runs
			COPY . → new
			```
	   **Second build**
			```
			FROM → cached
			COPY package.json → cached
			RUN npm install → cached
			COPY . → runs
			```
	
	> Leveraging Docker layer caching reduces **build times**, **storage usage**, and optimizes **CI/CD pipelines**.
	
---

## 5) Best Practices for Dockerfile Optimization

  1. **Use minimal base images**
     
	```
	FROM node:18-alpine       
	```
  - Smaller image size  
  - Faster pulls  
  - Reduced attack surface  
	
 2. **Use multi-stage builds**

	```
	FROM node:18 AS build
	RUN npm run build
	
	FROM nginx:alpine
	COPY --from=build /app/dist /usr/share/nginx/html
	```
  - Keeps final image **clean and lightweight**  
  - Removes build tools from runtime image  
  - Standard in production to separate build-time and runtime concerns  
	
3. **Minimize number of layers**
		```
		RUN apt update && apt install -y curl
		```
	- Combine related RUN commands  
	
4. **Avoid running containers as root**
	```dockerfile
	USER node
	```
	- Improves security  
	
5. **Use `.dockerignore`**
	- Prevents unnecessary files from entering the image  
	- Reduces build time and image size  
	
6. **Prefer COPY over ADD**
	- COPY is **explicit and predictable**  
	- ADD has extra behavior (auto-extract, URLs)	
	- Dockerfile optimization impacts **image size**, **security**, **deployment speed**, and **scalability** in production environments.
	
---

## Summary
A Dockerfile defines how an image is built using **layered, cached instructions**. Optimizing **layer order**, **cache usage**, **security**, and **image size** is critical for **fast**, **secure**, and **reproducible CI/CD pipelines.

