
# ------------------------------------------
# EC2 Instance Outputs
# ------------------------------------------

output "ec2_instance_names" {
  description = "Names of all EC2 instances"
  value       = aws_instance.my_ec2[*].tags.Name
}


output "ec2_instance_ids" {
  description = "IDs of all created EC2 instances"
  value       = aws_instance.my_ec2[*].id
}

output "ec2_public_ips" {
  description = "Public IP addresses of all EC2 instances"
  value       = aws_instance.my_ec2[*].public_ip
}

output "ec2_private_ips" {
  description = "Private IP addresses of all EC2 instances"
  value       = aws_instance.my_ec2[*].private_ip
}

