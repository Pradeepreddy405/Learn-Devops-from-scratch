
# --------------------------------------------------
# Create EC2 Instance
# --------------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  availability_zone = "us-east-1a"

  tags = {
    Name = "Terraform-EC2-Instance"
  }
}


# --------------------------------------------------
# Create EBS Volume
# --------------------------------------------------

resource "aws_ebs_volume" "my_ebs_volume" {

  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name = "Terraform-EBS-Volume"
  }
}


# --------------------------------------------------
# Attach EBS Volume to EC2 Instance
# --------------------------------------------------

resource "aws_volume_attachment" "ebs_attachment" {

  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.my_ebs_volume.id
  instance_id = aws_instance.my_ec2.id

  force_detach = false
}
