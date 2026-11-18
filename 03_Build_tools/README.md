# Build and Deployment Tools – Fundamentals

## Introduction

Build and Deployment tools are essential components of modern DevOps and Cloud workflows. They help automate software compilation, testing, packaging, artifact management, and application delivery.

Understanding the difference between Build and Deploy is important before moving into CI/CD automation.

Let's break it down from scratch!

---

## 1. What is Build?

**Build** is the process of transforming source code into a usable software artifact.

It typically involves:

- Compiling source code.
- Resolving project dependencies.
- Running automated tests.
- Packaging application files.
- Generating deployable artifacts.

The objective is to create a usable, functional version of an application.

### Common Build Outputs (Artifacts)

| Application Type | Build Output |
|---|---|
| Desktop Applications | `.exe`, `.dmg`, `.app` |
| Java Applications | `.jar`, `.war` |
| Android Applications | `.apk`, `.aab` |
| iOS Applications | `.ipa` |
| Web Applications | `.zip`, `.tar.gz`, bundled assets |
| Containerized Applications | Docker Images |

### Examples

**Example 1: Java Application**

Maven or Gradle manages the Java build process, including compilation, testing, dependency management, and packaging.

Output:
- `application.jar`
- `application.war`

**Example 2: Python Application**

PyInstaller packages Python applications and their dependencies into executable distributions.

Output:
- `application.exe` (Windows)

---

## 2. What is Deploy?

**Deploy** is the process of delivering a built application to a target environment so that it can be executed or accessed by users.

The target environment could be:

- Physical servers
- Virtual machines (AWS EC2)
- Cloud platforms
- Container platforms (Docker/Kubernetes)
- Mobile devices
- Application stores

### Examples

**Example 1: Java Application**

1. Generate a JAR file using Maven.
2. Transfer the JAR file to an AWS EC2 instance.
3. Configure the required Java runtime.
4. Start the application.
5. Verify application accessibility.

**Example 2: Android Application**

Upload an Android application package to the Google Play Console for distribution.

---

## 3. How Build and Deploy Work Together

Build and Deploy are important stages in Continuous Integration (CI) and Continuous Delivery/Deployment (CD).

They work together to automate software delivery.

- Build creates and validates the application artifact.
- Deploy delivers the artifact to the target environment.
- CI/CD tools automate and coordinate these processes.

### Important Points

- A build can happen without deployment (for example, during development or testing).
- Applications can be deployed to development, testing, and staging environments before production.
- A successful build does not automatically guarantee a successful deployment.

### Basic Workflow

```text
Source Code
    |
    v
   BUILD
    |
    v
Application Artifact
    |
    v
  DEPLOY
    |
    v
Target Environment
    |
    v
Application Available to Users
```

---

## 4. Build vs Deploy – Key Differences

| Build | Deploy |
|---|---|
| Creates the application artifact | Delivers the application |
| Transforms source code | Takes the built artifact |
| Compiles and tests code | Configures and starts the application |
| Generates JAR, WAR, ZIP, etc. | Runs the application in a target environment |
| Example: Maven, Gradle | Example: Ansible, deployment scripts, Argo CD |

---

## 5. Common Build and Deployment Tools

### Build Tools

| Tool | Purpose |
|---|---|
| Maven | Java build automation and dependency management |
| Gradle | Build automation for Java and other JVM projects |
| npm | JavaScript package management and script execution |
| Webpack | JavaScript application bundling |
