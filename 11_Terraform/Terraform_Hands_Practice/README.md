# Terraform Hands-on Practice – Complete Learning Roadmap

**From Absolute Beginner to Advanced | AWS | Infrastructure as Code | DevOps Engineering**

## 📌 About This Repository

This repository documents my practical learning journey with Terraform, starting from fundamental concepts and progressing towards advanced Infrastructure as Code (IaC) implementation.

The primary objective is to understand Terraform by executing real-world AWS infrastructure scripts, troubleshooting errors, managing infrastructure, and eventually building reusable Terraform modules.

### Learning Approach

1. Learn Terraform fundamentals.
2. Execute raw Terraform scripts without modules.
3. Understand each resource and configuration block.
4. Practise Terraform variables, outputs, functions, and expressions.
5. Build AWS infrastructure using Terraform.
6. Learn Terraform state management and remote backends.
7. Implement advanced Terraform concepts.
8. Convert raw Terraform scripts into reusable modules.
9. Build production-style AWS infrastructure projects.
10. Integrate Terraform into CI/CD pipelines.

---

# Phase 1: Terraform Fundamentals – Raw Scripts

**Goal:** Understand how Terraform provisions and manages AWS infrastructure using individual Terraform configuration files without modules.

| No. | Task | Terraform Concepts | Status |
|---|---|---|---|
| 01 | Create an EC2 Instance | `aws_instance` | ⬜ |
| 02 | Create a Security Group | `aws_security_group` | ⬜ |
| 03 | Create EC2 with Security Group | Resource References | ⬜ |
| 04 | Create an AWS Key Pair | `aws_key_pair` | ⬜ |
| 05 | Create EC2 with User Data | User Data / Bootstrap | ⬜ |
| 06 | Create an EBS Volume | `aws_ebs_volume` | ⬜ |
| 07 | Attach EBS Volume to EC2 | `aws_volume_attachment` | ⬜ |
| 08 | Create an Elastic IP | `aws_eip` | ⬜ |
| 09 | Associate Elastic IP with EC2 | Resource Dependencies | ⬜ |
| 10 | Create Multiple EC2 Instances | `count` | ⬜ |

# Phase 2: AWS Networking with Terraform

**Goal:** Understand how to create AWS networking infrastructure from scratch.

| No. | Task | Terraform Concepts | Status |
|---|---|---|---|
| 11 | Create a VPC | `aws_vpc` | ⬜ |
| 12 | Create a Public Subnet | `aws_subnet` | ⬜ |
| 13 | Create a Private Subnet | Private Networking | ⬜ |
| 14 | Create an Internet Gateway | `aws_internet_gateway` | ⬜ |
| 15 | Create a Route Table | `aws_route_table` | ⬜ |
| 16 | Associate Route Table with Subnet | `aws_route_table_association` | ⬜ |
| 17 | Create a NAT Gateway | `aws_nat_gateway` | ⬜ |
| 18 | Allocate Elastic IP for NAT Gateway | `aws_eip` | ⬜ |
| 19 | Create Network ACL | `aws_network_acl` | ⬜ |
| 20 | Build Complete VPC Architecture | Resource Dependencies | ⬜ |

# Phase 3: Terraform Variables, Outputs and Expressions

**Goal:** Learn how to write dynamic and flexible Terraform configurations.

| No. | Task | Terraform Concepts | Status |
|---|---|---|---|
| 21 | Create EC2 Using Input Variables | `variable` | ⬜ |
| 22 | Practise Different Variable Types | String, Number, Bool, List, Map | ⬜ |
| 23 | Use terraform.tfvars | Variable Assignment | ⬜ |
| 24 | Create Terraform Outputs | `output` | ⬜ |
| 25 | Use Local Values | `locals` | ⬜ |
| 26 | Fetch Existing AWS Resources | `data` sources | ⬜ |
| 27 | Create Multiple Resources Using for_each | `for_each` | ⬜ |
| 28 | Create Conditional Resources | Conditional Expressions | ⬜ |
| 29 | Create Dynamic Security Group Rules | `dynamic` blocks | ⬜ |
| 30 | Understand Resource Dependencies | `depends_on` | ⬜ |

# Phase 4: AWS Services and Infrastructure

**Goal:** Practise provisioning different AWS services using Terraform.

| No. | Task | Terraform Concepts | Status |
|---|---|---|---|
| 31 | Create an S3 Bucket | `aws_s3_bucket` | ⬜ |
| 32 | Configure S3 Versioning | Bucket Versioning | ⬜ |
| 33 | Create an IAM User | `aws_iam_user` | ⬜ |
| 34 | Create an IAM Role | `aws_iam_role` | ⬜ |
| 35 | Attach IAM Policies | IAM Policy Attachment | ⬜ |
| 36 | Create Application Load Balancer | ALB | ⬜ |
| 37 | Create Target Group | Target Group | ⬜ |
| 38 | Create ALB Listener | HTTP / HTTPS | ⬜ |
| 39 | Create Auto Scaling Group | ASG | ⬜ |
| 40 | Create RDS Instance | Database Infrastructure | ⬜ |
| 41 | Create CloudWatch Alarms | Monitoring | ⬜ |
| 42 | Create Route 53 DNS Records | DNS Management | ⬜ |

# Phase 5: Advanced Terraform Concepts

**Goal:** Understand Terraform state, lifecycle management, workspaces, debugging, and advanced configuration.

| No. | Task | Terraform Concepts | Status |
|---|---|---|---|
| 43 | Understand Terraform Lifecycle | `lifecycle` | ⬜ |
| 44 | Practise Terraform Provisioners | `local-exec`, `remote-exec` | ⬜ |
| 45 | Work with Terraform Workspaces | Dev / QA / Production | ⬜ |
| 46 | Import Existing AWS Resources | `terraform import` | ⬜ |
| 47 | Manage Terraform State | State Commands | ⬜ |
| 48 | Move Resources in Terraform State | `terraform state mv` | ⬜ |
| 49 | Remove Resources from Terraform State | `terraform state rm` | ⬜ |
| 50 | Terraform State Backup and Recovery | State Management | ⬜ |
| 51 | Configure Remote Backend Using S3 | Remote State | ⬜ |
| 52 | Understand State Locking | State Consistency | ⬜ |
| 53 | Practise Terraform Functions | Built-in Functions | ⬜ |
| 54 | Practise Terraform Expressions | Expressions and Operators | ⬜ |
| 55 | Terraform Debugging and Troubleshooting | `TF_LOG` | ⬜ |

# Phase 6: Real-World AWS Infrastructure Projects

**Goal:** Combine individual Terraform scripts to build practical AWS infrastructure architectures.

## Project 01: Single-Tier Architecture

**Components:**
- AWS VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Group
- EC2 Instance
- Elastic IP

**Expected Learning:**
- Build networking from scratch.
- Deploy an EC2 instance in a public subnet.
- Configure SSH and HTTP access.
- Understand complete resource dependencies.

Status: ⬜ Not Started

## Project 02: Two-Tier Architecture

**Components:**
- AWS VPC
- Public and Private Subnets
- Internet Gateway
- NAT Gateway
- Application EC2 Instances
- RDS Database
- Security Groups

**Expected Learning:**
- Separate application and database layers.
- Configure private networking.
- Establish secure communication between tiers.
- Deploy application infrastructure.

Status: ⬜ Not Started

## Project 03: Highly Available AWS Architecture

**Components:**
- Multiple Availability Zones
- Public and Private Subnets
- Application Load Balancer
- Target Groups
- Auto Scaling Group
- EC2 Instances
- NAT Gateway
- RDS
- CloudWatch Monitoring

**Expected Learning:**
- High availability.
- Fault tolerance.
- Auto scaling.
- Load balancing.
- Production infrastructure design.

Status: ⬜ Not Started

---

# Phase 7: Terraform Modules – From Raw Scripts to Reusable Modules

**Goal:** Convert previously executed raw Terraform configurations into reusable and maintainable modules.

| No. | Task | Concepts | Status |
|---|---|---|---|
| 56 | Understand Terraform Modules | Module Fundamentals | ⬜ |
| 57 | Understand Root and Child Modules | Module Architecture | ⬜ |
| 58 | Create First Local Module | Local Module | ⬜ |
| 59 | Call Child Module from Root Module | `module` and `source` | ⬜ |
| 60 | Pass Input Variables to Modules | Module Inputs | ⬜ |
| 61 | Return Module Outputs | Module Outputs | ⬜ |
| 62 | Create Reusable EC2 Module | EC2 Module | ⬜ |
| 63 | Create Reusable Security Group Module | Security Group Module | ⬜ |
| 64 | Create Reusable VPC Module | VPC Module | ⬜ |
| 65 | Create Multiple EC2 Instances Using Modules