# Module 5: Jenkins Pipeline Basics



##  Why Pipelines Matter

Traditional Jenkins Freestyle jobs are limited because they are:
- Not version-controlled
- Hard to scale
- Manually configured
- Difficult to maintain in teams

Jenkins Pipelines solve this by introducing **Pipeline as Code**, where the entire CI/CD workflow is written in a file called a **Jenkinsfile**.

This enables:
- Automation
- Reusability
- Version control using Git
- Collaboration in DevOps teams

---

##  CI/CD FLOW (Core DevOps Understanding)

```
Developer → Git Push → Jenkins Pipeline → Build → Test → Deploy
```

Every Jenkins concept maps into this flow:
- Git stores code + Jenkinsfile
- Jenkins triggers automation
- Pipeline defines workflow
- Stages define CI/CD phases
- Steps execute actual commands

---

##  Declarative vs Scripted Pipelines

### Declarative Pipeline (Recommended)

Declarative pipelines are structured, readable, and widely used in production environments.

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building application...'
            }
        }
    }
}
```

**Key advantages:**
- Easy to read
- Standardized structure
- Preferred in enterprise DevOps

---

###  Scripted Pipeline

Scripted pipelines are flexible and written using Groovy scripting.

```groovy
node {
    stage('Build') {
        echo 'Building application...'
    }
}
```

**Key advantages:**
- Full control over logic
- Used for complex workflows
- Less structured compared to Declarative

---

###  Connection Between Both

Declarative is like a framework, Scripted is like raw programming.  
Most real-world companies prefer Declarative for consistency.

---

##  Jenkinsfile Structure

A Jenkinsfile defines the entire CI/CD pipeline as code.

```groovy
pipeline {
    agent any

    environment {
        APP_NAME = "my-app"
    }

    stages {
        stage('Build') {
            steps {
                echo "Building ${APP_NAME}"
            }
        }

        stage('Test') {
            steps {
                echo "Testing ${APP_NAME}"
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying ${APP_NAME}"
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution completed'
        }
    }
}
```

###  Breakdown
- `pipeline` → Entire CI/CD workflow  
- `agent` → Where pipeline runs  
- `environment` → Variables  
- `stages` → CI/CD phases  
- `steps` → Commands inside stages  
- `post` → Actions after execution  

---

##  Stages & Steps

### Stages
Stages represent logical phases of CI/CD:
- Build  
- Test  
- Deploy  

### Steps
Steps are actual commands executed inside stages.

```groovy
stage('Test') {
    steps {
        echo 'Running tests...'
        sh 'npm test'
    }
}
```

###  Connection
- Stage = WHAT happens  
- Step = HOW it happens  

---

##  Agents

Agents define where the pipeline runs.

```groovy
agent any
```

OR

```groovy
agent {
    label 'docker-agent'
}
```

###  Connection
Agents enable distributed builds across multiple machines, improving scalability.

---

##  Environment Variables

Used to store reusable values.

```groovy
environment {
    ENV = "production"
}
```

Usage:

```groovy
echo "Deploying to ${ENV}"
```

###  Connection
Environment variables prevent hardcoding and support multi-environment deployments (dev/test/prod).

---

##  Post Actions

Post actions run after pipeline execution regardless of result.

```groovy
post {
    success {
        echo 'Build successful!'
    }
    failure {
        echo 'Build failed!'
    }
    always {
        echo 'Cleanup running...'
    }
}
```

###  Connection
Used for:
- Notifications
- Cleanup tasks
- Logging
- Monitoring integrations

---

##  HANDS-ON SECTION

###  Step 1: Create Jenkins Pipeline Job
1. Open Jenkins Dashboard  
2. Click **New Item**  
3. Select **Pipeline**  
4. Name it → `my-pipeline`  
5. Click OK  

---

###  Step 2: Basic Pipeline Example

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building application...'
            }
        }

        stage('Test') {
            steps {
                echo 'Testing application...'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
            }
        }
    }
}
```

---

###  Step 3: Multi-Stage Real-World Pipeline

```groovy
pipeline {
    agent any

    environment {
        APP_NAME = "demo-app"
    }

    stages {

        stage('Checkout') {
            steps {
                git 'https://github.com/your-repo/demo.git'
            }
        }

        stage('Build') {
            steps {
                echo "Building ${APP_NAME}"
            }
        }

        stage('Test') {
            steps {
                echo "Testing ${APP_NAME}"
            }
        }

        stage('Deploy') {
            steps {
                echo "Deploying ${APP_NAME}"
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
```

---

###  Step 4: Store Jenkinsfile in Git

#### Why Git Integration Matters
- Version control for pipelines  
- Team collaboration  
- Industry-standard DevOps practice  

#### Git Commands

```bash
git init
git add .
git commit -m "Add Jenkinsfile"
git branch -M main
git remote add origin <repo-url>
git push -u origin main
```

#### Jenkins Configuration
- Choose **Pipeline from SCM**
- Select **Git**
- Provide repository URL
- Run pipeline

---

##  END-TO-END CI/CD FLOW

```
Git Repository (Jenkinsfile)
        ↓
Jenkins triggers pipeline
        ↓
Agent executes jobs
        ↓
Stages run sequentially
        ↓
Steps execute commands
        ↓
Post actions handle results
```

---

##  Interview Preparation (VERY IMPORTANT)

Be ready to explain:
- Pipeline as Code
- Declarative vs Scripted pipelines
- Role of Jenkinsfile in CI/CD
- Multi-stage pipelines
- Jenkins + Git integration
- Purpose of agents
- Post actions and failure handling

---

##  Practice Ideas

- Add Maven build (`mvn clean install`)
- Add Docker image build stage
- Deploy to AWS EC2
- Integrate Slack/email notifications
- Add rollback strategy for failures

---

##  Final Summary

You now understand:
- Jenkins pipeline architecture
- Jenkinsfile structure
- CI/CD lifecycle in real systems
- Multi-stage automation pipelines
- Git-based pipeline management

Caution : This is a **core foundation skill for DevOps engineers working in production environments **