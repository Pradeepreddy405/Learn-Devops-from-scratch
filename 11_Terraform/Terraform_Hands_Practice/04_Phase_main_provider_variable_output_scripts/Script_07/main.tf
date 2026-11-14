resource "aws_ebs_volume" "my_ebs" {

  availability_zone = var.availability_zone
  size              = var.ebs_volume_size
  type              = var.ebs_volume_type

  tags = {
    Name = var.ebs_name
  }
}