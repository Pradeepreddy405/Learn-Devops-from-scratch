# ------------------------------------------
# Security Group Outputs
# ------------------------------------------

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_sg.id
}


# ------------------------------------------
# EC2 Instance Outputs
# ------------------------------------------

output "ec2_instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.my_ec2.id
}

output "ec2_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.my_ec2.public_ip
}