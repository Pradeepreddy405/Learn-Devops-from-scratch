# AWS Provider Configuration

provider "aws" {
  region = "us-east-1"
  profile = "terraform-lab"
}

# Create EC2 Instance

resource "aws_instance" "web-server" {
  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Raw-EC2"
  }
}