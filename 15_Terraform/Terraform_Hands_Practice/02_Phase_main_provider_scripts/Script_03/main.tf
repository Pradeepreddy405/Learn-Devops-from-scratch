# Create Security Group

resource "aws_security_group" "web_sg" {

  name        = "terraform-web-sg"
  description = "Security group created using Terraform"

  # Inbound Rules

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Terraform-Web-SG"
  }
}


# Output Details of the Security Group

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
