# Build Tools

### 1) Build :	
- The process of transforming source code into a runnable application. This typically includes compiling, running automated tests, and packaging the code with necessary dependencies into an artifact.

- To generate a usable version of the application (or) we can say that to create a usable, functional version of the application.	
- Common Build Outputs (Artifacts):
  
			Desktop Apps		: .exe (Windows), .dmg (macOS), .app
			Java Applications	: .jar (Java ARchive), .war (Web Application Archive)
			Mobile Apps			: .apk (Android), .ipa (iOS)
			Web Apps			: Bundled/Minified assets like .zip or .tar.gz packages
			Containers			: Docker images
			
- Examples:
	- Maven/Gradle compile Java code into a .jar file
	- PyInstaller packages Python scripts into a .exe

---

### 2) Deploy : 
- The process of taking the built application and delivering it to a live environment where users can access it.
- To make the application available on target environments such as servers, cloud infrastructure, user devices, or an app store.
		
- Examples:
			Deploying a .jar file to a server and starting the service
			Uploading an .apk to the Google Play Store for distribution


---


### 3) How BUILD and DEPLOY Work Together
- Build are a critical part of the Continuous Integration (CI) and Continuous Delivery/Deployment (CD) pipeline because they ensure that code can be reliably built, tested, and packaged before deployment.
- Build tools can be integrated with deployment tools to automate the entire path from code → build → deploy (commonly known as CI/CD).
- A build may occur without deployment (e.g., internal testing).
- Deployments often go first to staging or test environments before reaching production.

- ### WORKFLOW
Build 	→ produces the artifact
Deploy 	→ delivers and runs it for users
Often automated together in CI/CD pipelines

		
---		
		
### 4) Summary  :	
1) 	Build tools automate the creation, testing, packaging, and deployment preparation of software, making them a core part of DevOps pipelines.
2) 	Build	Create an executable version	.jar, .exe, .apk, etc.
3) 	Deploy	Make that executable available to users	Live/usable app
4)	You can also build without deploying (internal testing), and you can deploy to test environments before production.

---
			
Workflow : 	Developer pushes code ➜ CI/CD tool detects change ➜ runs Build Tool ➜ creates artifact ➜ deploys to environment
				
			Developer writes code
					↓
			Git Push
					↓
			CI Tool (Jenkins/GitLab/GitHub Actions)
					↓
			Build Tool (Maven/Gradle/npm)
					↓
			Artifact Generated (.jar/.war/.zip)
					↓
			Artifact Repository (Nexus/Artifactory)
					↓
			Deployment (Docker/K8s/EC2)
