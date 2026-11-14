
# ==========================================
# CREATE SECURITY GROUP
# ==========================================

resource "aws_security_group" "web_sg" {

  name        = "terraform-userdata-sg"
  description = "Allow HTTP and SSH traffic"

  # Inbound HTTP Traffic
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Inbound SSH Traffic
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Terraform-UserData-SG"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}


# ==========================================
# CREATE EC2 INSTANCE WITH USER DATA
# ==========================================

resource "aws_instance" "web_server" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = <<-EOF
    #!/bin/bash

    dnf update -y

    dnf install nginx -y

    systemctl enable nginx
    systemctl start nginx

    echo "<h1>Hello from Terraform User Data!</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name        = "Terraform-UserData-EC2"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}


# ==========================================
# SECURITY GROUP OUTPUTS
# ==========================================

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.web_sg.id
}

output "security_group_name" {
  description = "Security Group Name"
  value       = aws_security_group.web_sg.name
}

output "security_group_arn" {
  description = "Security Group ARN"
  value       = aws_security_group.web_sg.arn
}

output "security_group_vpc_id" {
  description = "VPC ID"
  value       = aws_security_group.web_sg.vpc_id
}

output "security_group_ingress_rules" {
  description = "Security Group Inbound Rules"
  value       = aws_security_group.web_sg.ingress
}

output "security_group_egress_rules" {
  description = "Security Group Outbound Rules"
  value       = aws_security_group.web_sg.egress
}

output "security_group_tags" {
  description = "Security Group Tags"
  value       = aws_security_group.web_sg.tags
}


# ==========================================
# EC2 INSTANCE OUTPUTS
# ==========================================

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.web_server.id
}

output "instance_arn" {
  description = "EC2 Instance ARN"
  value       = aws_instance.web_server.arn
}

output "instance_public_ip" {
  description = "EC2 Public IP"
  value       = aws_instance.web_server.public_ip
}

output "instance_private_ip" {
  description = "EC2 Private IP"
  value       = aws_instance.web_server.private_ip
}

output "instance_public_dns" {
  description = "EC2 Public DNS"
  value       = aws_instance.web_server.public_dns
}

output "instance_private_dns" {
  description = "EC2 Private DNS"
  value       = aws_instance.web_server.private_dns
}

output "instance_type" {
  description = "EC2 Instance Type"
  value       = aws_instance.web_server.instance_type
}

output "instance_ami" {
  description = "EC2 AMI ID"
  value       = aws_instance.web_server.ami
}

output "instance_availability_zone" {
  description = "EC2 Availability Zone"
  value       = aws_instance.web_server.availability_zone
}

output "instance_security_groups" {
  description = "Security Groups attached to EC2"
  value       = aws_instance.web_server.vpc_security_group_ids
}

output "instance_tags" {
  description = "EC2 Instance Tags"
  value       = aws_instance.web_server.tags
}
