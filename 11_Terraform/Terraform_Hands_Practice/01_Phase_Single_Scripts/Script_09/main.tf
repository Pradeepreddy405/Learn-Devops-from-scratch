
# --------------------------------------------------
# AWS Provider Configuration
# --------------------------------------------------

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-lab"
}

# --------------------------------------------------
# Create EC2 Instance
# --------------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2-Instance"
  }
}

# --------------------------------------------------
# Allocate Elastic IP
# --------------------------------------------------

resource "aws_eip" "my_eip" {

  domain = "vpc"

  tags = {
    Name        = "Terraform-Elastic-IP"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# --------------------------------------------------
# Associate Elastic IP with EC2
# --------------------------------------------------

resource "aws_eip_association" "eip_association" {

  instance_id   = aws_instance.my_ec2.id
  allocation_id = aws_eip.my_eip.id
}
