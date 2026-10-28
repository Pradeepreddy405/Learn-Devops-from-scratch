# Terraform Learning Roadmap

This repository provides a comprehensive roadmap to learn **Terraform** from fundamentals to advanced concepts, CI/CD integration, and production-ready practices. Follow the modules step-by-step to gain hands-on experience and build your Terraform portfolio.

---

## **Module 1: Terraform Fundamentals**
**Goal:** Understand Terraform, Infrastructure as Code (IaC), and basic Terraform workflow.

**Topics:**
- What is Terraform? Why IaC matters
- Terraform vs other IaC tools (CloudFormation, Ansible)
- Terraform workflow: Write → Plan → Apply → Destroy
- Terraform architecture: Providers, Resources, State, Modules
- Terraform installation (Linux / Windows / Mac)

  **Terraform CLI basics:**

    ```bash
    terraform --version
    terraform init
    terraform plan
    terraform apply
    terraform destroy
    ```
      Hands-on:
      - Install Terraform and verify version
      - Initialize a Terraform project
      - Create a simple AWS EC2 instance or S3 bucket
      - Apply changes and destroy resources safely

---

## **Module 2: Terraform Configuration Basics**
**Goal:** Learn Terraform syntax, resources, variables, and outputs.

**Topics:**
- Terraform configuration files: `.tf` and `.tfvars`
- Resources and Providers
- Variables: string, number, list, map
- Outputs: retrieving resource info
- Understanding dependencies between resources

      Hands-on:
      - Create an EC2 instance with variables for instance type, AMI, and region
      - Output instance ID and public IP
      - Use `terraform plan` to preview changes

---

## **Module 3: Terraform State & Remote Backend**
**Goal:** Manage Terraform state safely, locally and remotely.

**Topics:**
- Terraform state: local vs remote
- Backend types: S3, Terraform Cloud, etc.
- State locking with DynamoDB (AWS)
- Import existing resources into Terraform state
- State commands: `terraform state list`, `terraform state show`, `terraform import`

        Hands-on:
      - Configure an S3 backend with state locking using DynamoDB
      - Import an existing S3 bucket into Terraform
- Modify resources and safely update state

---

## **Module 4: Terraform Modules**
**Goal:** Learn modular and reusable Terraform code.

**Topics:**
- What are Terraform modules?
- Local vs remote modules
- Input and output variables in modules
- Module versioning and best practices

      Hands-on:
      - Create a reusable module for EC2 + Security Group
      - Create a module for an S3 bucket with versioning
      - Use modules to deploy multiple environments

---

## **Module 5: Terraform Workspaces & Environment Management**
**Goal:** Manage multiple environments efficiently.

**Topics:**
- Terraform workspaces: dev, staging, prod
- Environment-specific variables
- Managing secrets with AWS SSM or Secrets Manager
- Conditional resources with `count` and `for_each`

      Hands-on:
      - Create workspaces for dev and prod
      - Deploy same infrastructure in multiple environments
      - Use variables to customize configurations per workspace

---

## **Module 6: Advanced Terraform Concepts**
**Goal:** Handle complex infrastructure and dynamic configurations.

**Topics:**
- Terraform functions (`concat`, `lookup`, `join`, etc.)
- Dynamic blocks and conditional expressions
- `count` vs `for_each` for multiple resources
- Lifecycle rules: `create_before_destroy`, `prevent_destroy`
- Terraform formatting, validation, and linting best practices

      Hands-on:
      - Use `for_each` to create multiple EC2 instances
      - Apply conditional resource creation
      - Use dynamic blocks in a security group module

---

## **Module 7: Terraform with Cloud Providers**
**Goal:** Integrate Terraform with cloud services.

**Topics:**
- AWS Provider: VPC, EC2, S3, RDS, IAM
- GCP Provider: Compute Engine, Cloud Storage, IAM
- Azure Provider: VM, Storage Account, Networking
- Tagging, naming conventions, and resource organization

      Hands-on:
      - Deploy a VPC with subnets, security groups, and EC2 instances
      - Create an S3 bucket with versioning and IAM policy
      - Deploy RDS/MySQL instance with Terraform

---

## **Module 8: Terraform CI/CD & Automation**
**Goal:** Automate Terraform deployments using pipelines.

**Topics:**
- Terraform Cloud / Terraform Enterprise overview
- GitHub Actions, GitLab CI, or Jenkins with Terraform
- Plan and apply in pipelines
- Automated state management and locking

      Hands-on:
      - Build a GitHub Actions pipeline to apply Terraform on push
      - Automate Terraform plan and apply with approval workflow
      - Integrate remote state backend in CI/CD

---

## **Module 9: Terraform Best Practices & Production Readiness**
**Goal:** Ensure maintainable and scalable Terraform code.

**Topics:**
- Code organization (env folders, modules, main.tf, variables.tf)
- Secrets and sensitive variables management
- Versioning Terraform providers and modules
- Backup and recovery of Terraform state
- Handling drift detection and remediation

      Hands-on:
      - Refactor Terraform code into modules
      - Use sensitive variables for passwords or keys
      - Test drift detection and reconcile infrastructure

---

## **Module 10: Projects & Portfolio**
**Project Ideas:**
- Single-tier AWS Web App: EC2 + Security Group + S3
- Multi-tier AWS App: VPC + Subnets + EC2 + RDS + S3
- Kubernetes Cluster Deployment: EKS with Terraform modules
- CI/CD Pipeline with Terraform: Automated infra deployment via GitHub Actions
- Hybrid Cloud Deployment: AWS + GCP resources managed by Terraform
- Deploy a full stack application using Terraform modules
- Use workspaces for dev/staging/prod
- Automate deployment with CI/CD pipeline

---


## **License**
This roadmap is provided for learning purposes. You are free to use and modify it for your personal projects.
