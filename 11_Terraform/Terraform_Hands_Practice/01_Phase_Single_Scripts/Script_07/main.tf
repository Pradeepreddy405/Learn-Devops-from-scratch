
# --------------------------------------------------
# AWS Provider Configuration
# --------------------------------------------------

provider "aws" {
  region  = "us-east-1"
  profile = "terraform-lab"
}

# --------------------------------------------------
# Create an EBS Volume
# --------------------------------------------------

resource "aws_ebs_volume" "my_ebs_volume" {

  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "My EBS Volume"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

