
# ------------------------------------------
# Security Group Outputs
# ------------------------------------------

output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.web_sg.id
}

output "security_group_name" {
  description = "Name of the created Security Group"
  value       = aws_security_group.web_sg.name
}


# ------------------------------------------
# EC2 Instance Outputs
# ------------------------------------------

output "ec2_instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.my_ec2.id
}

output "ec2_public_ip" {
  description = "Public IP address of EC2 instance"
  value       = aws_instance.my_ec2.public_ip
}

output "ec2_private_ip" {
  description = "Private IP address of EC2 instance"
  value       = aws_instance.my_ec2.private_ip
}

output "ec2_instance_type" {
  description = "Instance type of EC2"
  value       = aws_instance.my_ec2.instance_type
}


# ------------------------------------------
# EBS Volume Outputs
# ------------------------------------------

output "ebs_volume_id" {
  description = "ID of the created EBS volume"
  value       = aws_ebs_volume.my_ebs_volume.id
}

output "ebs_volume_size" {
  description = "Size of EBS volume in GB"
  value       = aws_ebs_volume.my_ebs_volume.size
}

output "ebs_volume_arn" {
  description = "ARN of the EBS volume"
  value       = aws_ebs_volume.my_ebs_volume.arn
}

output "ebs_availability_zone" {
  description = "Availability Zone of EBS volume"
  value       = aws_ebs_volume.my_ebs_volume.availability_zone
}
