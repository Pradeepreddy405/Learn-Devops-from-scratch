
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
