# AWS Provider Configuration

provider "aws" {
  region = "us-east-1"
  #  profile = "terraform-lab"  -----> Instead of using profile , i will configure profile info in env variable

  # Set the profile             ---> $env:AWS_PROFILE = "terraform-lab"
  # verify the profile          ---> echo $AWS_PROFILE
  # Unset the profile           ---> Remove-Item Env:AWS_PROFILE
  # verify the authenticaton    ---> aws sts get-caller-identity
}

# Create EC2 Instance

resource "aws_instance" "web-server" {
  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Raw-EC2"
  }
}