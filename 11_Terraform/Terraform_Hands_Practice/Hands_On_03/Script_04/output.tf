
# ==========================================
# SECURITY GROUP OUTPUTS
# ==========================================

# Security Group ID
output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_sg.id
}

# Security Group Name
output "security_group_name" {
  description = "Security Group Name"
  value       = aws_security_group.web_sg.name
}

# Security Group ARN
output "security_group_arn" {
  description = "Security Group ARN"
  value       = aws_security_group.web_sg.arn
}

# Security Group VPC ID
output "security_group_vpc_id" {
  description = "Security Group VPC ID"
  value       = aws_security_group.web_sg.vpc_id
}

# Security Group Ingress Rules
output "security_group_ingress_rules" {
  description = "Security Group Inbound Rules"
  value       = aws_security_group.web_sg.ingress
}

# Security Group Egress Rules
output "security_group_egress_rules" {
  description = "Security Group Outbound Rules"
  value       = aws_security_group.web_sg.egress
}

# Security Group Tags
output "security_group_tags" {
  description = "Security Group Tags"
  value       = aws_security_group.web_sg.tags
}


# ==========================================
# EC2 INSTANCE OUTPUTS
# ==========================================

# EC2 Instance ID
output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

# EC2 Instance ARN
output "instance_arn" {
  description = "EC2 Instance ARN"
  value       = aws_instance.web_server.arn
}

# EC2 Public IP
output "instance_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.web_server.public_ip
}

# EC2 Private IP
output "instance_private_ip" {
  description = "EC2 Private IP"
  value       = aws_instance.web_server.private_ip
}

# EC2 Public DNS
output "instance_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.web_server.public_dns
}

# EC2 Private DNS
output "instance_private_dns" {
  description = "EC2 Private DNS"
  value       = aws_instance.web_server.private_dns
}

# EC2 Instance Type
output "instance_type" {
  description = "EC2 Instance Type"
  value       = aws_instance.web_server.instance_type
}

# EC2 AMI ID
output "instance_ami" {
  description = "EC2 AMI ID"
  value       = aws_instance.web_server.ami
}

# EC2 Availability Zone
output "instance_availability_zone" {
  description = "EC2 Availability Zone"
  value       = aws_instance.web_server.availability_zone
}

# EC2 Security Groups
output "instance_security_groups" {
  description = "Security Groups attached to EC2"
  value       = aws_instance.web_server.vpc_security_group_ids
}

# EC2 Instance Tags
output "instance_tags" {
  description = "EC2 Instance Tags"
  value       = aws_instance.web_server.tags
}
