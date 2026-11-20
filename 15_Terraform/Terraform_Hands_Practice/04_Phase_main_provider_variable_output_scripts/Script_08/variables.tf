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

variable "sg_name" {
  description = "Name of the Security Group"
  type        = string
  default     = "terraform-sg"
}

variable "ssh_cidr" {
  description = "Your public IP address allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "http_cidr" {
  description = "Your public IP address allowed for HTTP"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "outbound_cidr" {
  description = "Outbound CIDR for all traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "ec2_name" {
  description = "Name of the EC2 Instance"
  type        = string
  default     = "Terraform-EC2-Instance-from-variables"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c230065b91270bc6"
}



variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "Availability Zone for the EBS volume"
  type        = string
  default     = "us-east-1a"
}

variable "ebs_name" {
  description = "Name of the EBS Volume"
  type        = string
  default     = "Terraform-EBS-Volume-from-variables"
}