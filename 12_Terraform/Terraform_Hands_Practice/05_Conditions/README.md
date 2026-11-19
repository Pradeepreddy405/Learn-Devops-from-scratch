# Terraform Conditional Expressions

## 1. Overview

Terraform conditional expressions allow us to make dynamic decisions based on specified conditions.

They help us control resource configurations and resource creation based on environment variables, Boolean values, and logical conditions.

### Why do we use Conditional Expressions?

- Select different EC2 instance types based on environments.
- Create resources conditionally.
- Enable or disable monitoring.
- Configure different values for Dev, QA, and Production environments.
- Control infrastructure deployment dynamically.

## 2. Conditional Expression Syntax

Terraform uses the ternary operator.

```hcl
condition ? true_value : false_value
```

**Example:**

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"
}
```

**Explanation:**

- If the environment is `prod`, Terraform selects `t3.medium`.
- Otherwise, Terraform selects `t2.micro`.

## 3. Conditional Expression with EC2 Instance

**Objective:** Create an EC2 instance with a different instance type based on the environment.

```hcl
provider "aws" {
  region = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"

  instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"

  tags = {
    Name        = "My-EC2"
    Environment = var.environment
  }
}
```

## 4. Conditional Resource Creation Using count

**Objective:** Create an EC2 instance only when the environment is Production.

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-xxxxxxxxxxxxxxxxx"
  instance_type = "t2.micro"

  count = var.environment == "prod" ? 1 : 0

  tags = {
    Name = "Production-EC2"
  }
}
```

### Expected Behaviour

| Environment | Condition | Count | Result |
|---|---|---:|---|
| dev | false | 0 | No EC2 instance |
| qa | false | 0 | No EC2 instance |
| prod | true | 1 | One EC2 instance |

**Important:**

- `count = 1` creates one resource instance.
- `count = 0` creates no resource instances.

## 5. Conditional Expressions with Logical Operators

Terraform supports logical operators to evaluate multiple conditions.

| Operator | Description |
|---|---|
| `&&` | Logical AND |
| `\|\|` | Logical OR |
| `!` | Logical NOT |
| `==` | Equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |

**Example:**

```hcl
variable "environment" {
  type    = string
  default = "prod"
}

variable "enable_monitoring" {
  type    = bool
  default = true
}

locals {
  create_monitoring = var.environment == "prod" && var.enable_monitoring
}
```

Monitoring is enabled only when both conditions are true.

## 6. Nested Conditional Expressions

We can evaluate multiple conditions using nested ternary operators.

```hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_type = var.environment == "prod" ? "t3.large" : var.environment == "qa" ? "t3.medium" : "t2.micro"
}
```

### Expected Behaviour

| Environment | Instance Type |
|---|---|
| Production | t3.large |
| QA | t3.medium |
| Development | t2.micro |

For complex configurations, maps and the `lookup()` function can make the code easier to maintain.

## 7. Conditional Expression vs count

| Feature | Conditional Expression | count |
|---|---|---|
| Purpose | Select a value | Control resource instances |
| Syntax | `condition ? A : B` | `count = condition ? 1 : 0` |
| Select instance type | Yes | No, not directly |
| Skip resource creation | Not by itself | Yes |

## 8. Hands-on Practice Tasks

1. Create an EC2 instance with `t3.medium` for Production and `t2.micro` for Development.
2. Create an EC2 instance only when the environment is Production.
3. Enable monitoring only when the environment is Production and monitoring is enabled.
4. Configure different EC2 instance types for Dev, QA, and Production.
5. Create an S3 bucket only when `enable_s3` is true.

## 9. Important Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy
```

## 10. Key Takeaways

- Conditional expressions use the ternary operator.
- Conditional expressions help select values dynamically.
- `count` can conditionally control resource creation.
- Logical operators help evaluate multiple conditions.
- Nested conditions support multiple environment configurations.
- Maps and `lookup()` are useful alternatives for complex conditional logic.

