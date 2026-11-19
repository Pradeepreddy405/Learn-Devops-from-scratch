#  Jenkins Zero to Hero – Module 1 (Fundamentals)


##  What You Will Learn

This module covers the **absolute core concepts** every DevOps engineer must know:

* What Jenkins is and why it exists
* CI vs CD (real-world understanding)
* Jenkins vs other CI tools
* Jenkins Architecture (Controller, Agents, Executors)
* Jenkins Job Lifecycle
* Jenkins File System
* Hands-on setup (Linux & Docker)

---

##  1. What is Jenkins?

**Jenkins** is an Open-source automation tool used to implement CI/CD (Continuous Integration / Continuous Delivery) in DevOps.
It is widely used to build, test, and deploy applications automatically whenever code changes happen.

**Jenkins** is an open-source automation server used to:

* Build applications
* Run tests automatically
* Deploy applications

   - In simple terms: Jenkins removes manual work from software delivery.

###  Real Problem It Solves

Before Jenkins:

* Developers built code manually
* Testing was inconsistent
* Deployments were risky

With Jenkins:

* Everything is automated
* Builds are consistent
* Failures are caught early

---

##  2. CI vs CD (Brutally Clear)

### Continuous Integration (CI)

* Developers push code frequently (daily or multiple times)
* Each commit is:

  * Built
  * Tested automatically

Goal: **Catch bugs early**

---

### Continuous Delivery (CD)

* After CI succeeds:

  * Code is ready to deploy anytime
* Deployment is usually **manual approval**

Goal: **Always keep code deployable**

---

### Continuous Deployment (CD – Advanced)

* Fully automated deployment
* No manual approval

Goal: **Ship fast, automatically**

---

## 🆚 3. Jenkins vs Other CI Tools

| Tool           | Strength                                   | Weakness               |
| -------------- | ------------------------------------------ | ---------------------- |
| Jenkins        | Highly customizable, huge plugin ecosystem | Complex setup          |
| GitHub Actions | Easy integration with GitHub               | Less flexible          |
| GitLab CI      | Built-in DevOps platform                   | Heavy for small setups |
| CircleCI       | Fast & cloud-native                        | Limited free tier      |

Reality:

> Jenkins is still heavily used in enterprises because of flexibility.

---

##  4. Jenkins Architecture

###  Controller (Master)

* Brain of Jenkins
* Manages jobs, pipelines, UI

###  Agents (Workers)

* Execute actual tasks (build/test/deploy)
* Can be:

  * Linux servers
  * Docker containers
  * Kubernetes pods

###  Executors

* Slots inside agents
* Each executor runs **1 job at a time**

---

###  Simple Flow

```
Developer → Git Push → Jenkins Controller → Agent → Build/Test/Deploy
```

---

##  5. Jenkins Job Lifecycle

1. Code pushed to repository
2. Jenkins detects change (webhook/polling)
3. Job triggered
4. Build starts
5. Tests run
6. Results generated
7. Deployment (optional)

---

##  6. Jenkins File System

Default location:

```
/var/lib/jenkins/
```

### Important directories:

| Folder     | Purpose                   |
| ---------- | ------------------------- |
| jobs/      | Stores job configurations |
| workspace/ | Stores build files        |
| plugins/   | Installed plugins         |
| logs/      | System logs               |

Truth:

> If Jenkins breaks, most of your debugging happens here.

---

##  7. Hands-On Setup

---

###  Option 1: Install Jenkins using Docker (Recommended)

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  jenkins/jenkins:lts
```

---

###  Get Initial Password

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

---

###  Access Jenkins UI

Open browser:

```
http://localhost:8080
```

---

###  Initial Setup Steps

1. Enter admin password
2. Install suggested plugins
3. Create admin user
4. Start using Jenkins

---

##  8. Explore Jenkins UI

Key sections:

* Dashboard → Overview of jobs
* Manage Jenkins → Configuration & plugins
* Build History → Previous builds
* System Info → Environment details

---

##  Mini Task (Do This or You’re Wasting Time)

* Install Jenkins using Docker
* Create a freestyle job
* Run a simple shell command:

```bash
echo "Hello DevOps"
```

If you skip this → you’re just reading, not learning.

---

##  Outcome of This Module

After completing this module, you should:

* Understand **why Jenkins exists**
* Know **how CI/CD actually works**
* Be comfortable navigating Jenkins UI
* Run your **first job successfully**

---


##  Final Reality Check

Reading this won’t get you a job.

👉 Doing this + building projects WILL.

---

##  Contribute

Feel free to:

* Fork this repo
* Improve explanations
* Add real-world examples

---

