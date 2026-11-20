In DevOps, build tools are software tools that convert source code into a runnable application in an automated, repeatable way.
	They compile code, resolve dependencies, run tests, and package artifacts so they can be deployed.


Why build tools are important in DevOps

	1)Automation
	2)Consistency
	3)Speed
	4)Reliability

Build tools help by:
		1)Automating manual steps
		2)Avoiding “it works on my machine” issues
		3)Producing standard artifacts (JAR, WAR, ZIP, Docker image)
		4)Integrating easily with CI/CD tools (Jenkins, GitHub Actions, GitLab CI)
	

What exactly does a build tool do?
		1)Download dependencies
		2)Compile source code
		3)Run tests
		4)Package the application
		5)Generate build artifacts

Common Build Tools (Language-wise)

		Java
			Tool	Purpose
			Maven	Dependency management + build
			Gradle	Faster, modern alternative
			Ant	Old, script-based
			Output: .jar, .war
		
		Python
			Tool	Purpose
			pip	Install dependencies
			setuptools	Package Python apps
			poetry	Modern dependency & build tool
			Output: .whl, .tar.gz
		
		JavaScript / Node.js
			Tool	Purpose
			npm	Dependency + build scripts
			yarn	Faster npm alternative
			pnpm	Efficient dependency handling
			Output: dist/, build/
		
		.NET
			Tool	Purpose
			dotnet CLI	Restore, build, publish
			Output: .dll, .exe
		
		Go
			Tool	Purpose
			go build	Compile Go programs
			Output: Binary file
		
		
		OS-Level Build & Automation Tools
			These are often used in DevOps pipelines:
		
			Tool			Purpose
			=====			=================
			Make			Task automation
			Shell scripts	Custom build steps
			Docker			Build container images
			

Build tools in real DevOps pipeline
	1)	Java build
		mvn clean install
	
		1)Downloads dependencies
		2)Compiles code
		3)Runs tests
		4)Creates JAR/WAR

	2)	Python build
		pip install -r requirements.txt
		python setup.py build

		Node.js build
		npm install
		npm run build


Simple DevOps Flow

		Developer Code
			↓
		Build Tool (Maven / npm / pip)
			↓
		Artifact (JAR / ZIP / Image)
			↓
		CI/CD Tool (Jenkins)
			↓
		Deploy to Server / Kubernetes



Build tools are software tools used in DevOps to automate the process of compiling source code, managing dependencies, running tests, and packaging applications into deployable artifacts.