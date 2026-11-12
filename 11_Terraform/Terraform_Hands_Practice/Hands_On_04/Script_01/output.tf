
# EC2 Instance Name

output "instance_name" {
  description = "EC2 Instance Name"
  value       = aws_instance.my_ec2.tags["Name"]
}


# EC2 Instance ID

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.my_ec2.id
}

# EC2 Instance ARN

output "instance_arn" {
  description = "EC2 Instance ARN"
  value       = aws_instance.my_ec2.arn
}


# EC2 Instance Type

output "instance_type" {
  description = "EC2 Instance Type"
  value       = aws_instance.my_ec2.instance_type
}

# EC2 Public IP

output "public_ip" {
  description = "EC2 Public IP Address"
  value       = aws_instance.my_ec2.public_ip
}

# EC2 Private IP

output "private_ip" {
  description = "EC2 Private IP Address"
  value       = aws_instance.my_ec2.private_ip
}

# Availability Zone

output "availability_zone" {
  description = "EC2 Availability Zone"
  value       = aws_instance.my_ec2.availability_zone
}
