output "ec2_instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.my_ec2.id
}

output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.my_ec2.public_ip
}

output "ec2_instance_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.my_ec2.private_ip
}

output "ec2_instance_type" {
  description = "Instance type selected based on environment"
  value       = aws_instance.my_ec2.instance_type
}

output "ec2_availability_zone" {
  description = "Availability zone of the EC2 instance"
  value       = aws_instance.my_ec2.availability_zone
}

output "ec2_environment" {
  description = "Deployment environment"
  value       = aws_instance.my_ec2.tags["Environment"]
}

output "ec2_instance_name" {
  description = "Name tag of the EC2 instance"
  value       = aws_instance.my_ec2.tags["Name"]
}