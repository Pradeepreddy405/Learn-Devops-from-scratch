
# AWS Provider Configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.70.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

}
