# --------------------------------------------------
# Create EC2 Instance
# --------------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-EC2-Instance"
  }
}

# --------------------------------------------------
# Allocate Elastic IP
# --------------------------------------------------

resource "aws_eip" "my_eip" {

  domain = "vpc"

  tags = {
    Name        = "Terraform-Elastic-IP"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# --------------------------------------------------
# Associate Elastic IP with EC2
# --------------------------------------------------

resource "aws_eip_association" "eip_association" {

  instance_id   = aws_instance.my_ec2.id
  allocation_id = aws_eip.my_eip.id
}
# --------------------------------------------------
# EC2 Instance Outputs
# --------------------------------------------------

# EC2 Instance ID
output "ec2_instance_id" {
  value = aws_instance.my_ec2.id
}

# EC2 Instance Name
output "ec2_instance_name" {
  value = aws_instance.my_ec2.tags["Name"]
}

# EC2 Instance ARN
output "ec2_instance_arn" {
  value = aws_instance.my_ec2.arn
}

# EC2 Instance Public IP
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

# EC2 Instance Private IP
output "ec2_private_ip" {
  value = aws_instance.my_ec2.private_ip
}


# --------------------------------------------------
# Elastic IP Outputs
# --------------------------------------------------

# Elastic IP Allocation ID
output "eip_allocation_id" {
  value = aws_eip.my_eip.id
}

# Elastic IP Public Address
output "eip_public_ip" {
  value = aws_eip.my_eip.public_ip
}

# Elastic IP ARN
output "eip_arn" {
  value = aws_eip.my_eip.arn
}

# Elastic IP Name
output "eip_name" {
  value = aws_eip.my_eip.tags["Name"]
}

# Elastic IP Domain
output "eip_domain" {
  value = aws_eip.my_eip.domain
}

# Elastic IP Public DNS
output "eip_public_dns" {
  value = aws_eip.my_eip.public_dns
}


# --------------------------------------------------
# Elastic IP Association Outputs
# --------------------------------------------------

# Association ID
output "eip_association_id" {
  value = aws_eip_association.eip_association.id
}

# Associated Instance ID
output "eip_associated_instance_id" {
  value = aws_eip_association.eip_association.instance_id
}

# Associated Allocation ID
output "eip_associated_allocation_id" {
  value = aws_eip_association.eip_association.allocation_id
}

# Associated Public IP
output "eip_associated_public_ip" {
  value = aws_eip_association.eip_association.public_ip
}
