
resource "aws_instance" "my_ec2" {

  ami = var.aws_ami_id
  availability_zone = var.availability_zone

  instance_type = var.environment == "prod" ? "t3.medium" : "t2.micro"

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }
}
