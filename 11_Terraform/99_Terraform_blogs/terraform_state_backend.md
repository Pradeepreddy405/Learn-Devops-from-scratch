# Terraform State, Backend (S3 + DynamoDB), Remote Locking, Git Flow & Production Approval

> **From Zero to Hero – Practical README**

This README explains **Terraform state files**, **remote backend using S3**, **state locking with DynamoDB**, **Git-based workflow**, and **approval-based production deployments** in a clear, step-by-step DevOps-friendly way.

---

## 1. What is Terraform State?

Terraform keeps track of **real infrastructure** using a file called **terraform.tfstate**.

### Why state is needed
- Maps **Terraform resources → real cloud resources**
- Knows **what exists** and **what needs to change**
- Enables `plan`, `apply`, and `destroy`

### Problems with local state
❌ Stored on one laptop
❌ Team members overwrite each other
❌ No locking (race conditions)
❌ Risk of data loss

👉 **Solution: Remote State Backend**

---

## 2. Remote Backend using S3

We store the Terraform state file in **AWS S3** instead of local disk.

### Benefits
- Centralized state
- Team collaboration
- Versioning support
- Secure & durable

### S3 Bucket Requirements
- Versioning: ✅ ENABLED
- Encryption: ✅ ENABLED
- Private access only

### Example S3 Backend Configuration

```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```

---

## 3. State Locking with DynamoDB

### What is state locking?
State locking prevents **two people or pipelines** from running Terraform at the same time.

Without locking:
- Corrupted state
- Partial deployments
- Infrastructure mismatch

### Why DynamoDB?
- Fast
- Fully managed
- Strong consistency

### DynamoDB Table Requirements
| Setting | Value |
|------|------|
| Table Name | terraform-locks |
| Partition Key | LockID (String) |
| Capacity | On-Demand |

### Create DynamoDB Table (One-time)

```bash
aws dynamodb create-table \
  --table-name terraform-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```

---

## 4. Terraform Workflow (Remote State)

```text
terraform init   → connects to S3 backend
terraform plan   → reads state from S3 (LOCKED)
terraform apply  → updates infra + state (LOCKED)
terraform destroy→ removes infra safely
```

Lock is:
- Acquired before `plan/apply`
- Released after completion

---

## 5. Git-Based Terraform Workflow (Industry Standard)

### Repository Structure

```text
terraform-infra/
├── modules/
│   ├── vpc/
│   ├── ec2/
│   └── rds/
├── envs/
│   ├── dev/
│   ├── stage/
│   └── prod/
├── backend.tf
├── providers.tf
└── README.md
```

---

## 6. Branching Strategy

| Branch | Purpose |
|-----|-----|
| feature/* | New changes |
| dev | Development testing |
| stage | Pre-production |
| main | Production |

---

## 7. Approval-Based Production Deployment

### Golden Rule
> ❌ **NO DIRECT APPLY TO PROD FROM LOCAL MACHINE**

### Flow

```text
Developer → Feature Branch
          ↓ PR
        Dev Branch
          ↓ Auto Plan
        Stage Branch
          ↓ Manual Approval
        Main (Prod)
          ↓ Apply
```

---

## 8. CI/CD Pipeline Concept (Example)

### Dev Environment
- Auto `terraform plan`
- Auto `terraform apply`

### Stage Environment
- Auto `terraform plan`
- Manual approval
- Auto `terraform apply`

### Production
- Auto `terraform plan`
- ❗ Manual approval (Manager / Lead)
- Apply only after approval

---

## 9. Why Git Approval is Critical for Production

✅ Audit trail
✅ Change history
✅ Rollback support
✅ Compliance
✅ No accidental deletion

---

## 10. Security Best Practices

- Never commit `terraform.tfstate`
- Use IAM roles (not access keys)
- Enable S3 bucket versioning
- Enable S3 encryption
- Restrict DynamoDB access
- Use separate AWS accounts for dev/stage/prod

---

## 11. Common Mistakes (Avoid These)

❌ Local state for teams
❌ Running terraform apply directly in prod
❌ No state locking
❌ No approvals
❌ Mixing environments in one state file

---

## 12. Final DevOps Summary (Hero Level)

✔ Terraform state stored in S3
✔ Locked using DynamoDB
✔ Git-controlled infrastructure
✔ CI/CD based execution
✔ Manual approval for production
✔ Safe, scalable, enterprise-ready setup

---

