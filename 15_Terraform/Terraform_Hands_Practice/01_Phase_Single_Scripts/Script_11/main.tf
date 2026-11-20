
# ------------------------------------------
# AWS Provider Configuration
# ------------------------------------------

provider "aws" {
  region = "us-east-1"
  profile = "terraform-lab"
}

# ------------------------------------------
# Create EC2 Instances using count
# ------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t2.micro"

  count = 3

  tags = {
    Name = "Terraform-EC2"
  }
}

# ------------------------------------------
# Terraform still creates three EC2 instances, but all three instances will have the same Name tag
# ------------------------------------------



# ------------------------------------------
# Create S3 Buckets using count.index - ${count.index}
# ------------------------------------------

resource "aws_s3_bucket" "my_bucket" {

  count = 3

  bucket = "terraform-practice-bucket-${count.index}-unique-name"

  tags = {
    Name = "Terraform-Bucket-${count.index}"
  }
}
