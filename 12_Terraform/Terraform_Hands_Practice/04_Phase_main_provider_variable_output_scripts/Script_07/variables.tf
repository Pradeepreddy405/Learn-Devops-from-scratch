variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication "
  type        = string
  default     = "terraform-lab"
}

variable "ebs_name" {
  description = "Name of the EBS Volume"
  type        = string
  default     = "Terraform-EBS-Volume"
}

variable "ebs_volume_type" {
  description = "Type of the EBS Volume"
  type        = string
  default     = "gp3"
}

variable "ebs_volume_size" {
  description = "Size of the EBS Volume in GB"
  type        = number
  default     = 10
}

variable "availability_zone" {
  description = "Availability Zone for the EBS Volume"
  type        = string
  default     = "us-east-1a"
}