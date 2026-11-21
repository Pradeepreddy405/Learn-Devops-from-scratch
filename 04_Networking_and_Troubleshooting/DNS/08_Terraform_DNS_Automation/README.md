# 08 – Terraform DNS Automation with AWS Route 53

This lab introduces infrastructure as code for Route 53. It creates a public hosted zone and a DNS record. A public domain that you own is required before delegating real production traffic to the zone.

Official documentation:
- Terraform AWS provider: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- Route 53 hosted zone resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone
- Route 53 record resource: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

## 1. Prerequisites

- Terraform installed.
- AWS CLI installed and configured.
- An AWS identity with the required Route 53 permissions.
- A domain you own if you intend to update public registrar delegation.
- Basic knowledge of `terraform init`, `plan`, `apply`, and `destroy`.

Check identity:

```bash
aws sts get-caller-identity
```

Do not hardcode access keys in Terraform files. Prefer an AWS profile, environment-based credentials, or an approved role.

## 2. Project structure

```text
terraform-route53-lab/
├── provider.tf
├── variables.tf
├── main.tf
├── outputs.tf
└── .gitignore
```

## 3. Configure the provider

`provider.tf`

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-lab"
}
```

Use a profile that exists in your AWS CLI configuration. Adjust the provider version constraint to match the version you have tested and approved.

## 4. Define the domain variable

`variables.tf`

```hcl
variable "domain_name" {
  description = "Domain name for the Route 53 public hosted zone"
  type        = string
}
```

## 5. Create a hosted zone

`main.tf`

```hcl
resource "aws_route53_zone" "public" {
  name = var.domain_name

  tags = {
    Environment = "lab"
    ManagedBy   = "Terraform"
  }
}
```

This creates a hosted zone. It does not automatically transfer domain registration or update nameservers at your registrar.

## 6. Create a DNS record

For a simple A record pointing to an IPv4 address, add the following to `main.tf`:

```hcl
resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.10"]
}
```

`192.0.2.10` is a documentation-only example address. Replace it with an endpoint you control before using the record for a real application.

## 7. Output hosted-zone details

`outputs.tf`

```hcl
output "hosted_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = aws_route53_zone.public.zone_id
}

output "name_servers" {
  description = "Authoritative nameservers assigned to the hosted zone"
  value       = aws_route53_zone.public.name_servers
}
```

## 8. Provide the input variable

Create `terraform.tfvars` locally:

```hcl
domain_name = "example.com"
```

Use a domain you own. Do not delegate a real domain to the new hosted zone until all required records have been recreated and reviewed.

## 9. Run Terraform

```bash
terraform fmt
terraform init
terraform validate
terraform plan
terraform apply
```

Review the plan before applying. Terraform will create billable AWS resources where applicable.

After creation, inspect the outputs:

```bash
terraform output
```

If the domain is already registered elsewhere, update the registrar's nameserver delegation only after carefully planning the DNS migration.

## 10. Verify DNS

After the hosted zone is authoritative and delegation is correctly configured:

```bash
dig example.com NS
dig app.example.com A
dig +trace app.example.com
```

A newly created hosted zone will not receive public queries for your domain until the domain is correctly delegated to its assigned nameservers.

## 11. Alias record for an Application Load Balancer

For an ALB, Route 53 supports Alias records. The Terraform record resource uses an alias block rather than an ordinary `records` and `ttl` configuration.

Illustrative example:

```hcl
resource "aws_route53_record" "app_alb" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "app.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}
```

This example assumes an `aws_lb.app` resource already exists in the same Terraform configuration and is an eligible target. Do not combine this Alias configuration with the ordinary `records` and `ttl` arguments for the same record.

## 12. Terraform state and Git security

Add a `.gitignore` file:

```gitignore
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
*.tfplan
crash.log
```

Review your organization's policy before ignoring or committing any variable files. Never commit credentials or secret values. Terraform state can contain sensitive infrastructure data and should be stored securely, commonly in a protected remote backend with locking where supported.

## 13. Cleanup

If this is a disposable lab, remove resources only after checking dependencies and the plan:

```bash
terraform plan -destroy
terraform destroy
```

Do not destroy a hosted zone that serves a live domain without an approved migration and rollback plan. A hosted zone with records or dependencies may require those records to be removed or managed appropriately before deletion.

## 14. Common errors

| Error | Possible reason | What to check |
|---|---|---|
| No credentials found | AWS identity not configured | AWS profile, role, environment |
| Access denied | IAM policy does not allow the action | Required Route 53 permissions |
| InvalidChangeBatch | Invalid record data or conflicting record | Name, type, values, existing records |
| Domain does not resolve | Registrar delegation not updated or wrong | NS delegation and `dig +trace` |
| Record returns old value | Cached DNS answer | TTL and resolver cache |
| Terraform wants to replace a resource | Configuration or immutable attribute change | Review the plan carefully |

## 15. Interview questions

1. Why use Terraform for DNS management?
2. Which Terraform resource creates a Route 53 hosted zone?
3. Which resource manages DNS records?
4. Does creating a hosted zone automatically update registrar nameservers?
5. How do you point a Route 53 record to an ALB?
6. Why must Terraform state be protected?
7. How would you safely migrate DNS from one provider to Route 53?

## 16. Key takeaway

Terraform makes DNS configuration repeatable, reviewable, and version-controlled. It does not remove the need for careful DNS migration planning, registrar delegation, state protection, and post-deployment verification.
