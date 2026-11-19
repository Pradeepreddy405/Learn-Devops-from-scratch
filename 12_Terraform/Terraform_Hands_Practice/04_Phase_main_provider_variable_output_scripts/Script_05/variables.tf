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


variable "key_name" {
  description = "Name of the AWS Key Pair"
  type        = string
  default     = "terraform-generated-key"
}
