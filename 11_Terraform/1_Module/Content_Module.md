# Module 01: Terraform Fundamentals – Beginner to Hands-on

![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange?logo=amazonaws)
![Level](https://img.shields.io/badge/Level-Beginner-green)
![Learning](https://img.shields.io/badge/Approach-Theory%20%2B%20Hands--On-blue)

## 1. Module Overview

Welcome to Module 01 of the Terraform learning series.

In this module, we will learn Terraform from absolute scratch. We will understand why Terraform is used, how Infrastructure as Code works, how Terraform communicates with cloud providers, and how to provision our first AWS resources.

The goal is not just to learn Terraform commands. The goal is to understand how infrastructure is designed, automated, deployed, tracked, and managed in real-world DevOps environments.

### Learning Objectives

By the end of this module, you should be able to:

- Understand Terraform and Infrastructure as Code.
- Explain why organizations use Terraform.
- Differentiate Terraform, Ansible, and CloudFormation.
- Understand Terraform architecture.
- Understand Providers, Resources, State, and Modules.
- Install Terraform on Linux, Windows, and macOS.
- Configure Terraform to communicate with AWS.
- Execute basic Terraform CLI commands.
- Provision an AWS resource using Terraform.
- Understand how to destroy infrastructure safely.

---

# 2. What Is Terraform?

Terraform is an Infrastructure as Code (IaC) tool developed by HashiCorp.

It allows us to provision, manage, and modify infrastructure using configuration files instead of manually creating resources through cloud consoles.

Terraform uses a declarative approach, meaning we define the desired infrastructure state, and Terraform determines the actions required to achieve that state.

### Simple Example

Imagine an organization wants to create 10 EC2 instances in AWS.

**Traditional approach:**

1. Log in to AWS Console.
2. Navigate to EC2.
3. Select an AMI.
4. Select an instance type.
5. Configure networking.
6. Configure security groups.
7. Launch instances.
8. Repeat the process for additional instances.

This approach involves repetitive manual work.

**Terraform approach:**

Instead of manually creating EC2 instances, we write Terraform configuration files describing the required infrastructure.

Terraform reads those files, checks the current infrastructure state, generates an execution plan, and provisions the resources after approval.

Example:

```hcl
resource "aws_instance" "web_server" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Web-Server"
  }
}
```

This configuration describes an AWS EC2 instance.

The AMI ID must be a valid AMI available in the selected AWS region.

### Why Do Organizations Use Terraform?

Organizations use Terraform for:

- Infrastructure automation.
- Consistent infrastructure deployment.
- Reducing manual configuration errors.
- Managing multiple environments.
- Reusing infrastructure configurations.
- Version-controlling infrastructure.
- Improving deployment repeatability.
- Managing infrastructure changes through code reviews.

### Real-World Use Cases

Terraform can automate the creation of:

| AWS Resource | Purpose |
|---|---|
| VPC | Isolated network |
| Subnets | Divide network infrastructure |
| EC2 | Virtual servers |
| S3 | Object storage |
| IAM | Identity and access management |
| Security Groups | Network traffic control |
| ALB | Application load balancing |
| ASG | Automatic scaling |
| RDS | Managed relational database |
| Route 53 | DNS management |

---

# 3. What Is Infrastructure as Code (IaC)?

Infrastructure as Code is the practice of managing and provisioning infrastructure through machine-readable configuration files instead of manually creating and configuring resources.

In simple terms:

**We write code to create and manage infrastructure.**

### Traditional Infrastructure vs IaC

| Traditional Infrastructure | Infrastructure as Code |
|---|---|
| Manual resource creation | Automated resource creation |
| Console-based operations | Code-based operations |
| Difficult to reproduce | Repeatable deployments |
| More manual effort | Reduced manual effort |
| Changes may be poorly documented | Changes can be version-controlled |
| Difficult to maintain consistency | Easier to maintain consistency |

### Real-World Example

Imagine an organization has four environments:

- Development
- Testing
- Staging
- Production

Each environment requires:

- 1 VPC
- 2 public subnets
- 2 private subnets
- 2 EC2 instances
- 1 Load Balancer
- Security Groups

Creating all these resources manually in four environments takes considerable effort.

Using IaC, we can define reusable infrastructure configurations and deploy consistent environments with different variables.

### Benefits of IaC

1. Automation – Reduce repetitive manual work.
2. Consistency – Deploy infrastructure using standardized configurations.
3. Scalability – Create or modify infrastructure efficiently.
4. Version Control – Track infrastructure changes using Git.
5. Reusability – Reuse Terraform modules.
6. Disaster Recovery – Recreate infrastructure from maintained configurations.
7. Collaboration – Allow teams to review infrastructure changes.

---

# 4. Terraform vs Ansible vs AWS CloudFormation

These tools are frequently used in DevOps environments, but their primary responsibilities are different.

| Feature | Terraform | Ansible | CloudFormation |
|---|---|---|---|
| Primary purpose | Infrastructure provisioning | Configuration management | AWS infrastructure provisioning |
| Developer | HashiCorp | Red Hat | AWS |
| Configuration | HCL | YAML | YAML / JSON |
| AWS support | Yes | Yes | Yes |
| Multi-cloud | Yes | Yes | No, AWS-focused |
| State management | Terraform state | No Terraform-style state file | AWS-managed stack state |
| Typical use | Create infrastructure | Configure servers | Create AWS infrastructure |

### When Should We Use Terraform?

Use Terraform when you want to provision and manage infrastructure.

Examples:

- Create VPCs.
- Create EC2 instances.
- Create Load Balancers.
- Create RDS databases.

### When Should We Use Ansible?

Use Ansible when you want to configure servers and automate operating-system tasks.

Examples:

- Install Nginx.
- Install Java.
- Configure users.
- Deploy applications.
- Manage services.

### How Terraform and Ansible Work Together

Consider a real-world application deployment.

1. Terraform creates AWS VPC and networking.
2. Terraform provisions EC2 instances.
3. Terraform creates security groups.
4. Ansible connects to EC2 instances through SSH.
5. Ansible installs Java and required packages.
6. Ansible deploys the application.
7. Ansible starts and manages application services.

**Interview Point:**

Terraform is primarily used for infrastructure provisioning, whereas Ansible is primarily used for configuration management and automation. Both tools can be integrated to automate the complete infrastructure and application deployment lifecycle.

---

# 5. Terraform Architecture

Before writing Terraform configurations, understand its major components.

## 5.1 Provider

A provider is a plugin that allows Terraform to communicate with an external platform or service.

Examples:

- AWS Provider
- Azure Provider
- Google Cloud Provider
- Kubernetes Provider
- GitHub Provider

Example:

```hcl
provider "aws" {
  region = "ap-south-1"
}
```

Explanation:

- `provider "aws"` tells Terraform to use the AWS provider.
- `region` specifies the AWS region.
- `ap-south-1` represents the Mumbai region.

## 5.2 Resources

A resource represents an infrastructure object that Terraform manages.

Examples:

- EC2 instance.
- S3 bucket.
- VPC.
- Security group.
- IAM role.

Example:

```hcl
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-terraform-practice-bucket-12345"
}
```

Explanation:

- `resource` declares an infrastructure resource.
- `aws_s3_bucket` is the resource type.
- `my_bucket` is the Terraform local resource name.
- `bucket` specifies the actual S3 bucket name.

The S3 bucket name must be globally unique.

## 5.3 State

Terraform state is a record of the infrastructure resources Terraform manages.

By default, Terraform stores state in a file named:

```text
terraform.tfstate
```

Why is state important?

Imagine Terraform creates three EC2 instances.

Terraform needs to maintain information about those resources so it can determine what currently exists and what changes are required.

The state file helps Terraform:

- Track managed resources.
- Associate configuration with real infrastructure.
- Identify resource changes.
- Understand resource dependencies.
- Determine what needs to be created, updated, or destroyed.

**Important:** State files may contain sensitive information. Never commit an unprotected Terraform state file to a public GitHub repository.

## 5.4 Modules

A Terraform module is a collection of Terraform configuration files organized together to create reusable infrastructure components.

Example:

```text
Terraform-Project/
│
├── main.tf
├── variables.tf
├── outputs.tf
│
└── modules/
    ├── vpc/
    ├── ec2/
    └── security-group/
```

Why do we use modules?

Imagine creating VPC infrastructure for Development, QA, and Production.

Instead of writing the same infrastructure configuration repeatedly, we can create a reusable VPC module and provide different variables to it.

This improves reusability and maintainability.

## 5.5 Backend

A backend defines where Terraform stores its state.

By default, Terraform uses a local backend and stores the state file in the working directory.

For team environments, organizations commonly use remote state storage such as an AWS S3 bucket.

A remote backend helps teams share and manage Terraform state.

State locking can prevent conflicting concurrent operations when supported and configured by the backend. For S3, native lockfile support is available through `use_lockfile = true`.

---

# 6. Terraform Workflow

Terraform follows a standard workflow.

```text
Write Configuration
        |
        v
terraform init
        |
        v
terraform validate
        |
        v
terraform plan
        |
        v
terraform apply
        |
        v
Infrastructure Created
        |
        v
Terraform State Updated
```

To remove managed infrastructure when required:

```text
terraform destroy
```

## 6.1 Write

Create Terraform configuration files.

Example:

```text
main.tf
variables.tf
outputs.tf
```

## 6.2 Initialize

Command:

```bash
terraform init
```

Purpose:

- Initializes the Terraform working directory.
- Downloads required providers.
- Initializes the configured backend.
- Prepares the project for execution.

Expected output includes:

```text
Terraform has been successfully initialized!
```

## 6.3 Validate

Command:

```bash
terraform validate
```

Purpose:

Checks whether the Terraform configuration is syntactically valid and internally consistent.

Expected output:

```text
Success! The configuration is valid.
```

## 6.4 Plan

Command:

```bash
terraform plan
```

Purpose:

Previews the changes Terraform intends to make.

Example output:

```text
Plan: 1 to add, 0 to change, 0 to destroy.
```

Meaning:

- Add one resource.
- Change zero resources.
- Destroy zero resources.

## 6.5 Apply

Command:

```bash
terraform apply
```

Purpose:

Executes the proposed infrastructure changes.

Terraform normally asks for confirmation before applying changes.

Type:

```text
yes
```

## 6.6 Destroy

Command:

```bash
terraform destroy
```

Purpose:

Removes infrastructure resources managed by the current Terraform configuration and state, subject to dependencies and lifecycle protections.

**Warning:** Always review the destruction plan before confirming. Never run destroy against production infrastructure without proper authorization and impact review