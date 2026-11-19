
# AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "terraform-lab"
}

# Create AWS Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "my-terraform-key"
  public_key = file(pathexpand("~/.ssh/terraform-key.pub"))

  # terraform-key.pub is the public key file generated using ssh-keygen command. Make sure to generate the key pair before running terraform apply command.

  tags = {
    Name        = "my-terraform-key"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}
