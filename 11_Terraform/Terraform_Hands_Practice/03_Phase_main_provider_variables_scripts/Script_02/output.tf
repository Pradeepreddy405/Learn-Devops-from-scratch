# Security Group ID
output "security_group_id" {
  description = "ID of the created Security Group"
  value       = aws_security_group.web_sg.id
}

# Security Group Name
output "security_group_name" {
  description = "Name of the created Security Group"
  value       = aws_security_group.web_sg.name
}

# Security Group ARN
output "security_group_arn" {
  description = "ARN of the created Security Group"
  value       = aws_security_group.web_sg.arn
}

# Security Group VPC ID
output "security_group_vpc_id" {
  description = "VPC ID associated with Security Group"
  value       = aws_security_group.web_sg.vpc_id
}

# Security Group Ingress Rules
output "security_group_ingress_rules" {
  description = "Inbound rules configured in Security Group"
  value       = aws_security_group.web_sg.ingress
}

# Security Group Egress Rules
output "security_group_egress_rules" {
  description = "Outbound rules configured in Security Group"
  value       = aws_security_group.web_sg.egress
}