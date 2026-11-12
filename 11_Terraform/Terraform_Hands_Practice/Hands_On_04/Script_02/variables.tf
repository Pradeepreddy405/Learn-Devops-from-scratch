# AWS Region

variable "aws_region" {
  description = "AWS region for creating resources"
  type        = string
  default     = "us-east-1"
}

# AWS Profile

variable "aws_profile" {
  description = "AWS CLI profile for authentication"
  type        = string
  default     = "terraform-lab"
}

# Security Group Name

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "Terraform-Web-SG"
}

# Security Group Description

variable "sg_description" {
  description = "Description of the Security Group"
  type        = string
  default     = "Security Group created using Terraform"
}

# SSH Port

variable "ssh_port" {
  description = "SSH port number"
  type        = number
  default     = 22
}

# HTTP Port

variable "http_port" {
  description = "HTTP port number"
  type        = number
  default     = 80
}

# SSH Allowed CIDR

variable "ssh_cidr" {
  description = "CIDR range allowed to access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

# HTTP Allowed CIDR

variable "http_cidr" {
  description = "CIDR range allowed to access HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}