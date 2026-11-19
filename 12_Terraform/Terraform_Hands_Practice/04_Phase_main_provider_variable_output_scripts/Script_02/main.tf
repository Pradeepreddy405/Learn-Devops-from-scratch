
# Create Security Group

resource "aws_security_group" "web_sg" {

  name        = var.sg_name
  description = var.sg_description

  # Inbound SSH Rule

  ingress {
    description = "Allow SSH"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr
  }

  # Inbound HTTP Rule

  ingress {
    description = "Allow HTTP"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.http_cidr
  }

  # Outbound Rule

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = var.sg_name
    ManagedBy = "Terraform"
  }
}
