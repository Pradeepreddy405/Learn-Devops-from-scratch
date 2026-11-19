
################################################################################
# PROJECT: CREATE EC2 INSTANCE USING TERRAFORM
# AUTHENTICATION: AWS PROFILE THROUGH ENVIRONMENT VARIABLES
################################################################################


################################################################################
# 1. AWS PROVIDER CONFIGURATION
################################################################################

provider "aws" {
  region = "us-east-1"

  # Instead of hardcoding the AWS profile here:
  # profile = "terraform-lab"

  # We configure AWS_PROFILE through environment variables.
}


################################################################################
# 2. CREATE EC2 INSTANCE
################################################################################

resource "aws_instance" "web-server" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Raw-EC2"
  }
}


################################################################################
# 3. AWS PROFILE CONFIGURATION USING POWERSHELL
################################################################################

# Set AWS profile:
# $env:AWS_PROFILE = "terraform-lab"

# Verify AWS profile:
# echo $env:AWS_PROFILE

# Verify AWS authentication:
# aws sts get-caller-identity

# Unset AWS profile:
# Remove-Item Env:AWS_PROFILE


################################################################################
# 4. AWS PROFILE CONFIGURATION USING WINDOWS CMD
################################################################################

# Set AWS profile:
# set AWS_PROFILE=terraform-lab

# Verify AWS profile:
# echo %AWS_PROFILE%

# Verify AWS authentication:
# aws sts get-caller-identity

# Unset AWS profile:
# set AWS_PROFILE=


################################################################################
# 5. AWS PROFILE CONFIGURATION USING LINUX / GIT BASH
################################################################################

# Set AWS profile:
# export AWS_PROFILE=terraform-lab

# Verify AWS profile:
# echo $AWS_PROFILE

# Verify AWS authentication:
# aws sts get-caller-identity

# Unset AWS profile:
# unset AWS_PROFILE


################################################################################
# 6. TERRAFORM EXECUTION COMMANDS
################################################################################

# Initialize Terraform:
# terraform init

# Format Terraform configuration:
# terraform fmt

# Validate Terraform configuration:
# terraform validate

# Generate execution plan:
# terraform plan

# Create EC2 instance:
# terraform apply

# View Terraform resources:
# terraform state list

# Destroy EC2 infrastructure:
# terraform destroy


################################################################################
# END OF CONFIGURATION
################################################################################
