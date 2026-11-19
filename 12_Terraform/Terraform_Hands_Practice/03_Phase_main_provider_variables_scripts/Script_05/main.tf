
# --------------------------------------------------
# Create an EBS Volume
# --------------------------------------------------

resource "aws_ebs_volume" "my_ebs_volume" {

  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name        = "My EBS Volume"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}


# --------------------------------------------------
# Read EBS Volume Details (Data Source)
# --------------------------------------------------

data "aws_ebs_volume" "existing" {

  filter {
    name   = "volume-id"
    values = [aws_ebs_volume.my_ebs_volume.id]
  }
}
