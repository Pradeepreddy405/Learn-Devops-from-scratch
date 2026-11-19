## 1 Why Continuous Integration ?
   - Continuous Integration is a practice where developers frequently merge code into a shared repository, and every change automatically triggers a pipeline that builds and tests the application.
     
   - In my projects, I used CI pipelines in tools like Jenkins / GitHub Actions to ensure every commit is validated before moving forward.
     
		Typically, most of the pipeline includes stages like:	
			- Dependency installation
			- Build
			- Unit testing
			- Code quality checks
  - This helps catch issues early, reduces integration conflicts, and ensures that the main branch is always in a deployable state.
	I also focused on optimizing pipelines by using caching and parallel execution to reduce build time.
	
   - Scenario : In one case, our builds were taking around 15 minutes, which slowed down releases. I optimized it by introducing parallel stages and dependency caching, reducing the build time to around 6 minutes.
	

-----------------------------------------------------------------------------------------------------------
## 2 What happens when pipeline fails ?
   - In one of our projects, whenever the CI/CD pipeline failed, we treated it as a production-impacting event rather than just a build issue.
     
   - First, we categorized failures into types like build failures, test failures, or infrastructure issues. For example, if it was a test failure, we checked logs and reports to identify flaky tests or genuine code issues. If it was a build failure, we analyzed dependency or Docker build problems.
     
   - We ensured immediate visibility using alerts integrated with tools like Slack and dashboards in Jenkins.
     
   - To reduce downtime, we implemented retry mechanisms for transient failures and isolated flaky tests so they wouldn't block deployments unnecessarily.
     
   - For long-term improvement, we focused on root cause analysis. For instance, we reduced failures caused by dependency downloads by introducing caching, and improved pipeline reliability by optimizing Docker layer usage.
	
This approach helped us reduce pipeline failure frequency and improved overall deployment speed and developer productivity.
	




-----------------------------------------------------------------------------------------------------------
## 3 How do you reduce CI time?

- Reducing CI time is critical for faster feedback and developer productivity. I focus on optimizing pipeline execution using techniques like parallelization, dependency caching, and minimizing unnecessary builds.
- For example, in a Jenkins pipeline using Jenkins, I reduced build time by splitting test and lint stages into parallel execution and caching dependencies, which significantly improved pipeline performance.
- I will consider pipeline failures are treated as system reliability issues, not just build errors, we focus on fast detection, root cause analysis, and preventing recurrence.
	
	
------------------------------------------------------------------------------------------------------------
## 4 What is the difference between CI and CD ?
   - CI focuses on integrating code changes frequently by running automated builds and tests to detect issues early.
   - CD extends this by automating the release process, either by preparing artifacts for manual deployment (continuous delivery) or automatically deploying them to production (continuous deployment). In short, CI ensures code quality, while CD ensures reliable and consistent releases.



------------------------------------------------------------------------------------------------------------
## 5 Continuous Deliver and Continuous Deployment
   - Continuous Delivery ensures that code is always in a deployable state, but requires a manual approval step before production release. Continuous Deployment removes that manual gate and automatically deploys every successful change to production.
   - In real-world enterprise environments, Continuous Delivery is more common due to compliance and risk management, whereas Continuous Deployment is adopted in highly mature DevOps setups with strong automated testing and monitoring.
	
	

------------------------------------------------------------------------------------------------------------	
## 6 What is a job in jenkins  ?
   - Job is a user-defined automation task or a set of sequential instructions that the Jenkins server executes to perform work

(or)
 
   - A Jenkins job is a repeatable automation unit, and each build is a traceable execution of that unit, with console logs acting as the primary debugging and audit mechanism.
   - Jobs are used for:
		- Build applications (Maven, Gradle, npm)
		- Run tests
		- Build Docker images
		- Deploy to Kubernetes
		- Trigger pipelines across systems
	

------------------------------------------------------------------------------------------------------------	
	
## 7 What is build in jenkins ?
   - In Jenkins, a build is a single execution instance of a Jenkins Project also known as a job.	
	(or)	
   - We can say that build in Jenkins is an automated process that takes your source code and transforms it into a working, deployable application
   - Usually build consists of 
		- Logs
		- Status (SUCCESS / FAILURE)
		- Timestamp
		- Artifacts (optional)
		
------------------------------------------------------------------------------------------------------------	
## What is workspace in jenkins ?
   - Workspace is a reusable execution directory per job where Jenkins runs build steps, while logs and history are stored separately under the job’s builds directory.


------------------------------------------------------------------------------------------------------------
## 8 Jenkins Workflow
   - Step 1 : Code in GitHub
   - Step 2 : Webhook configured
   - Step 3 : Jenkins Multibranch Pipeline
   - Step 4 : Triggers:
		    	PR → run tests
			    Merge to main → deploy
			

------------------------------------------------------------------------------------------------------------
## 9 Jenkins credentials ?
   - 1 Jenkins credentials are securely stored secrets used by pipelines/jobs to authenticate with external systems.
   - 2 Jenkins acts as a middleman that needs access to other systems without exposing secrets.
		- GitHub tokens
		- SSH keys
		- AWS access keys
		- Docker registry creds
		- Kubernetes kubeconfigs
        - API tokens
   - 3 Jenkins stores credentials in: /var/lib/jenkins/credentials.xml
   - 4 Global : Available to all jobs
   - 5 System : Only for internal Jenkins use
   - 6 Folder-level : Scoped to specific pipelines
   - 7 Use least privilege + scoped credentials
