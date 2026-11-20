# ------------------------------------------
# Create Security Group
# ------------------------------------------

resource "aws_security_group" "web_sg" {

  name        = "terraform-web-sg"
  description = "Allow SSH, HTTP"

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

  # Outbound Rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.outbound_cidr
  }

  tags = {
    Name = var.sg_name
  }
}

# ------------------------------------------
# Create EC2 Instance
# ------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type

  # Resource Reference
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = var.ec2_name
  }
}



# ------------------------------------------
# Create Elastic IP
# ------------------------------------------

resource "aws_eip" "my_eip" {

  domain = "vpc"

  # Associate Elastic IP with EC2
  instance = aws_instance.my_ec2.id

  tags = {
    Name = var.eip_name
  }
}
