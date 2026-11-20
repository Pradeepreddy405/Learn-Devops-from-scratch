
resource "aws_instance" "my_ec2" {

  ami               = var.aws_ami_id
  availability_zone = var.availability_zone
  instance_type     = var.instance_type

  monitoring = var.environment == "prod" && var.enable_monitoring

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
