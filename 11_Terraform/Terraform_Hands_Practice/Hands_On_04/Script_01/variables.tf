# ==========================================
# AWS Region
# ==========================================

variable "aws_region" {
  description = "AWS region for creating resources"
  type        = string
  default     = "us-east-1"
}



# ==========================================
# AWS Profile
# ==========================================


variable "aws_profile" {
  description = "AWS CLI profile for authentication"
  type        = string
  default     = "terraform-lab"
}



# ==========================================
# AMI ID
# ==========================================

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}


# ==========================================
# EC2 Instance Type
# ==========================================

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}



# ==========================================
# EC2 Instance Name
# ==========================================

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Terraform-EC2-Instance"
}