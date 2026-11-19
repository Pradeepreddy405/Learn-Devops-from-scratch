# 1 Problems before CI/CD and How CI/CD tools helped ?	
### 1️ Manual Builds
   - Developers built code manually on their own machines
   - Different environments → “Works on my machine” problem - dependency conflicts issues
   - No standard build process
   - Result: 
		- Inconsistent builds
		- frequent failures
		
### 2️ Late Detection of Bugs
   - Code was integrated after days or weeks
   - Bugs were found very late (during QA or production)
   - Result: 
		- Costly bug fixes
   		- Delayed releases
	
### 3️ No Automated Testing
   - Tests were run manually
   - Developers often skipped tests due to time pressure
   - Result: 
		- Broken features
     	- Low code quality
	
### 4️.Painful Code Integration (Merge Hell)
   - Developers worked on branches for a long time
   - Merging code caused conflicts and failures
   - Result: 
		- Integration nightmares
		- Unstable main branch ( Which leads to delay for deployment )
	
### 5️ Manual Deployments
   - Deployment steps written in documents or emails
   - Human errors during deployment
   - Result: 
		- Downtime
    	- Rollback issues
	
### 6️ No Visibility
   - No single place to know:
   - Build status
   - Test results
   - Who broke the build	
   - Result: 
		- Blame game
		- Slow troubleshooting
	
	
### 7 What is CICD  ?
   - CI/CD stands for Continuous Integration and Continuous Delivery (or Continuous Deployment).
   - It is a DevOps practice that automates the process of BUILDING, TESTING, and DEPLOYING code whenever developers make changes.
   
   - Continuous Integration is a development practice where developers frequently commit and merge code into a shared repository and every change is automatically triggers a pipeline that builds and test the application.
   
   - Continuous Delivery is nothing but, after CI builds and tests your code, it is automatically prepared and kept ready for deployment to production but, a human may still approve the final release.
   
   - Every successful change goes straight to production automatically, without  human approval or intervention called "Continuous Deployment".
	
### 8 What is jenkins ?
   - Jenkins is an Open-source automation tool used to implement CI/CD (Continuous Integration / Continuous Delivery) in DevOps.
   - It is widely used to build, test, and deploy applications automatically whenever code changes happen.
	


# 2 What Jenkins Solved ?
  Jenkins introduced Continuous Integration (CI).
### 1 Automated Builds
   - Automatically builds code on every commit
   - Same environment for everyone
   - Solved: Inconsistent builds

### 2️ Early Bug Detection
   - Runs build + tests immediately after code push
   - Bugs found within minutes
   - Solved: Late bug discovery

### 3 Automated Testing
   - Unit, integration, regression tests run automatically
   - Solved: Skipped or manual testing

### 4️ Continuous Integration
   - Developers merge code frequently
   - Jenkins integrates and validates changes continuously
   - Solved: Merge hell

### 5️ Automated Pipelines
   - Build → Test → Package → Deploy
   - One-click or fully automated releases
   - Solved: Manual deployments

### 6️ Centralized Visibility
	Dashboards show:
   - Build status
   - Logs
   - Test reports
	
	Solved: Lack of transparency

### 7️ Integration with DevOps Tools
Works with:
   - GitHub / GitLab
   - Docker
   - Kubernetes
   - SonarQube
   - AWS / Azure
	
	Solved: Tool fragmentation



	
# 3 CD (Continuous Delivery / Continuous Deployment)
   - While CI focuses on building and testing code, CD focuses on releasing that code to environments automatically.
   - In Continuous Delivery, code is automatically deployed to lower environments such as Dev, QA, and Staging, but production deployment requires manual approval.
   - Lower environments :
		- 1) Dev
		- 2) Qa
		- 3) Staging
					
   - Higher environments : 
		- 4) Prod  ----> Manual intervention needed through approvals
     
In Continuous Deployment, the entire process is fully automated, and successful builds are deployed to production without any manual intervention.

   ## Flow : Git → CI → Deploy to Dev → QA → (Manual Approve) → Prod

   ## Typical stages in pipeline : Commit → Build → Test → Deploy to Dev → Deploy to QA → Deploy to Staging → Manual Approval → Deploy to Prod

   ## Continuous delivery vs continuous deployment ?
   - Continuous Delivery ensures code is always ready for production with manual approval, 
   - whereas Continuous Deployment automatically deploys every successful build to production without human intervention.
