# ------------------------------------------
# Create Security Group
# ------------------------------------------

resource "aws_security_group" "web_sg" {

  name        = "terraform-web-sg"
  description = "Allow SSH, HTTP and HTTPS"

  # SSH Inbound Rule
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr
  }

  # HTTP Inbound Rule
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.http_cidr
  }

  # HTTPS Inbound Rule
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.https_cidr
  }

  # Outbound Rule
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

# ------------------------------------------
# Create EC2 Instance
# ------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type

  # Resource Reference
  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  tags = {
    Name = "Terraform-EC2"
  }
}