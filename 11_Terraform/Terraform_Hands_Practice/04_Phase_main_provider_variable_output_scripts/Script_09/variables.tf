
# ==================================================
# AWS Provider Variables
# ==================================================

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


# ==================================================
# Security Group Variables
# ==================================================

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "terraform-web-sg"
}

variable "ssh_cidr" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr" {
  description = "CIDR blocks allowed for HTTP access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "outbound_cidr" {
  description = "CIDR blocks allowed for outbound traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}


# ==================================================
# EC2 Instance Variables
# ==================================================

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ec2_name" {
  description = "Name of EC2 instance"
  type        = string
  default     = "Terraform-EC2-Instance"
}


# ==================================================
# Elastic IP Variables
# ==================================================

variable "eip_name" {
  description = "Name of Elastic IP"
  type        = string
  default     = "Terraform-EC2-EIP"
}
