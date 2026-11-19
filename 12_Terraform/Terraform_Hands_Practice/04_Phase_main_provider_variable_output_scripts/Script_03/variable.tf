# ------------------------------------------
# AWS Region
# ------------------------------------------

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


# ------------------------------------------
# AWS Profile
# ------------------------------------------

variable "aws_profile" {
  description = "AWS CLI profile"
  type        = string
  default     = "terraform-lab"
}


# ------------------------------------------
# EC2 Instance Variables
# ------------------------------------------

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

# ------------------------------------------
# Security Group Variables
# ------------------------------------------

variable "ssh_cidr" {
  description = "CIDR range allowed to access SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr" {
  description = "CIDR range allowed to access HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "https_cidr" {
  description = "CIDR range allowed to access HTTPS"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}