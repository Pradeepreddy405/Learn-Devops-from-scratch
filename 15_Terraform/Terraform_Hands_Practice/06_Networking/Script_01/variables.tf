variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile name"
  type        = string
  default     = "terraform-lab"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "terraform-networking-vpc"
}

variable "environment" {
  description = "Environment name for tagging"
  type        = string
  default     = "dev"
}