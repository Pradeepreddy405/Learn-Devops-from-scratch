resource "aws_instance" "my_ec2" {

  ami = var.aws_ami_id

  instance_type = var.environment == "prod" ? "t2.medium" : (var.environment == "qa" ? "t2.small" : "t2.micro")

  tags = {
    Name        = "Terraform-${var.environment}"
    Environment = var.environment
  }
}