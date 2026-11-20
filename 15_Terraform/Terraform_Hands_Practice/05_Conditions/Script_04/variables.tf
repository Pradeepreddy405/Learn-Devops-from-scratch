variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use for authentication"
  type        = string
  default     = "terraform-lab"
}

variable "availability_zone" {
  description = "The availability zone to deploy the EC2 instance in"
  type        = string
  default     = "us-east-1a"
}


variable "aws_ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}


variable "environment" {
  description = "The environment for the EC2 instance (e.g., dev, qa, prod)"
  type        = string
  default     = "dev"
}

