output "availability_zone" {
  value = var.availability_zone
}

output "aws_region" {
  value = var.aws_region
}

output "aws_profile" {
  value = var.aws_profile
}


output "aws_instance_name" {
  value = aws_instance.my_ec2.tags["Name"]
}

output "aws_instance_id" {
  value = aws_instance.my_ec2.id
}

output "aws_instance_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

output "environment" {
  value = var.environment
}

output "instance_type" {
  value = aws_instance.my_ec2.instance_type
}