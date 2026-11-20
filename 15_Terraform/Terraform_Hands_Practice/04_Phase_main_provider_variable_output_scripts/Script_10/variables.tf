
# ------------------------------------------
# AWS Provider Variables
# ------------------------------------------

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "terraform-lab"
}


# ------------------------------------------
# EC2 Instance Variables
# ------------------------------------------

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c230065b91270bc6"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 3
}

variable "instance_name" {
  description = "Base name for EC2 instances"
  type        = string
  default     = "Terraform-EC2"
}
