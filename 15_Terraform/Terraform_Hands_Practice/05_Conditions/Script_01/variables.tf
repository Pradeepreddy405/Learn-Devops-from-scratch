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


variable "availability_zone" {
  description = "Availability Zone for the EBS Volume"
  type        = string
  default     = "us-east-1a"
}


variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "Terraform-EC2-Instance"
}

variable "aws_ami_id" {
  description = "AWS AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}


#Terraform creates a t2.medium instance because the default environment is prod.

If you change the environment to prod, Terraform selects t3.medium.
variable "environment" {
  description = "Environment for the EC2 instance"
  type        = string
  default     = "prod"
}
