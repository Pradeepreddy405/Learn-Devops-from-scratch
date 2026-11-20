
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS profile"
  type        = string
  default     = "terraform-lab"
}

variable "key_name" {
  description = "Name of AWS key pair"
  type        = string
  default     = "terraform-key"
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/terraform-key.pub"
}