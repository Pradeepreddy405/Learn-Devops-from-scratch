
resource "aws_instance" "my_ec2" {

  ami               = var.aws_ami_id
  availability_zone = var.availability_zone

  instance_type = var.environment == "prod" ? var.instance_type_prod : var.environment == "qa" ? var.instance_type_Qa : var.instance_type_dev
  count         = var.environment == "prod" ? 2 : 0


  tags = {
    Name        = "${var.instance_name}-${count.index + 1}"
    Environment = var.environment
  }
}
