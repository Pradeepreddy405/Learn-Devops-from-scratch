#  Module 6: Advanced Jenkins Pipelines

---

#  Table of Contents

1. Parallel Stages  
2. Conditional Execution  
3. Input Approvals  
4. Retry & Timeout  
5. Error Handling & Notifications  
6. Performance Optimization  
7. Hands-On Tasks  
8. Final Production Pipeline  

---

# 1️ Parallel Stages

##  What
Run multiple stages **at the same time** instead of sequentially.

##  Why
- Reduces total execution time  
- Speeds up testing  

##  Step-by-Step
1. Create a pipeline  
2. Add a stage  
3. Use `parallel` block  
4. Add multiple sub-stages inside  

##  Example

```groovy
pipeline {
    agent any

    stages {
        stage('Parallel Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'echo Running Unit Tests'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'echo Running Integration Tests'
                    }
                }
                stage('UI Tests') {
                    steps {
                        sh 'echo Running UI Tests'
                    }
                }
            }
        }
    }
}
```

---

# 2️ Conditional Execution

##  What
Run a stage **only when a condition is met**.

##  Why
- Prevent unnecessary execution  
- Protect production  

##  Step-by-Step
1. Define a stage  
2. Add `when` block  
3. Specify condition  

##  Example

```groovy
stage('Deploy to Production') {
    when {
        branch 'main'
    }
    steps {
        sh 'echo Deploying to Production'
    }
}
```

##  Advanced Condition

```groovy
when {
    expression { env.BUILD_NUMBER.toInteger() > 10 }
}
```

---

# 3️ Input Approvals (Manual Gate)

##  What
Pause pipeline and wait for **human approval**.

##  Why
- Prevent accidental deployments  
- Add control for production  

##  Step-by-Step
1. Add stage before deployment  
2. Use `input` step  
3. Provide message  

##  Example

```groovy
stage('Approval') {
    steps {
        input message: 'Deploy to production?', ok: 'Approve'
    }
}
```

---

# 4️ Retry & Timeout

##  What
- Retry → Re-run failed steps  
- Timeout → Stop long-running tasks  

##  Why
- Handles temporary failures  
- Prevents pipeline hanging  

---

##  Retry

###  Steps
1. Wrap step in `retry(n)`  
2. Set retry count  

```groovy
stage('Build') {
    steps {
        retry(3) {
            sh 'echo Building...'
        }
    }
}
```

---

##  Timeout

###  Steps
1. Wrap step in `timeout`  
2. Define time and unit  

```groovy
stage('Test') {
    steps {
        timeout(time: 5, unit: 'MINUTES') {
            sh 'echo Running tests'
        }
    }
}
```

---

# 5️⃣ Error Handling & Notifications

##  What
Define actions after pipeline execution.

##  Why
- Detect failures quickly  
- Notify team  

##  Step-by-Step
1. Add `post` block  
2. Define:
   - success  
   - failure  
   - always  

##  Example

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'exit 1'
            }
        }
    }

    post {
        success {
            echo 'Build Successful'
        }
        failure {
            echo 'Build Failed'
        }
        always {
            echo 'Pipeline Completed'
        }
    }
}
```

##  Email Example

```groovy
post {
    failure {
        mail to: 'team@example.com',
             subject: 'Build Failed',
             body: 'Check Jenkins pipeline'
    }
}
```

---

# 6️ Performance Optimization

##  What
Improve pipeline speed and efficiency.

##  Why
- Saves time  
- Improves developer productivity  

##  Steps

###  Use Parallel Execution
- Run tasks simultaneously  

###  Use Lightweight Agents
- Prefer Docker over VMs  

###  Avoid Rework
- Cache dependencies  

```groovy
stage('Install Dependencies') {
    steps {
        sh 'npm install'
    }
}
```

###  Clean Workspace

```groovy
post {
    always {
        cleanWs()
    }
}
```

---

# 7️ Hands-On Tasks

##  Task 1: Parallel Execution
- Create 3 test stages  
- Run them in parallel  

##  Task 2: Conditional Deployment
- Deploy only on `main` branch  

##  Task 3: Manual Approval
- Add approval before production  

---

# 8️ Final Production Pipeline

```groovy
pipeline {
    agent any

    stages {

        stage('Build') {
            steps {
                retry(2) {
                    sh 'echo Building application'
                }
            }
        }

        stage('Parallel Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'echo Unit Tests'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'echo Integration Tests'
                    }
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                sh 'echo Deploying to Staging'
            }
        }

        stage('Approval') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to Production?', ok: 'Yes'
            }
        }

        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                timeout(time: 10, unit: 'MINUTES') {
                    sh 'echo Deploying to Production'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline Successful'
        }
        failure {
            echo 'Pipeline Failed'
        }
        always {
            cleanWs()
        }
    }
}
```

---

#  Final Reality

If your pipeline:
- Runs sequentially only  
- Has no conditions  
- Has no approval  
- Has no retry/timeout  
- Has no notifications  

