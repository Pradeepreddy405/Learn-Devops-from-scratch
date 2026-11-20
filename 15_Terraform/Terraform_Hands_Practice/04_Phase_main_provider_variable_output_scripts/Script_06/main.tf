
# --------------------------------------------------
# Step 1: Create Security Group
# --------------------------------------------------

resource "aws_security_group" "web_sg" {

  name        = "terraform-web-sg"
  description = "Allow SSH and HTTP traffic"

  # SSH Access
  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr
  }

  # HTTP Access
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound Traffic
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


# --------------------------------------------------
# Step 2: Create EC2 Instance with User Data
# --------------------------------------------------

resource "aws_instance" "web_server" {

  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash

              yum update -y
              yum install -y nginx

              systemctl start nginx
              systemctl enable nginx

              echo "<h1>Welcome to Terraform User Data</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Terraform-UserData-EC2"
  }
}
