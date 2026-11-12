
# --------------------------------------------------
# EC2 Instance Outputs
# --------------------------------------------------

# EC2 Instance ID
output "ec2_instance_id" {
  value = aws_instance.my_ec2.id
}

# EC2 Instance ARN
output "ec2_instance_arn" {
  value = aws_instance.my_ec2.arn
}

# EC2 Instance Name
output "ec2_instance_name" {
  value = aws_instance.my_ec2.tags["Name"]
}

# EC2 Instance Type
output "ec2_instance_type" {
  value = aws_instance.my_ec2.instance_type
}

# AMI ID
output "ec2_ami_id" {
  value = aws_instance.my_ec2.ami
}

# Availability Zone
output "ec2_availability_zone" {
  value = aws_instance.my_ec2.availability_zone
}

# Public IP
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}

# Private IP
output "ec2_private_ip" {
  value = aws_instance.my_ec2.private_ip
}


# --------------------------------------------------
# EBS Volume Outputs
# --------------------------------------------------

# EBS Volume ID
output "ebs_volume_id" {
  value = aws_ebs_volume.my_ebs_volume.id
}

# EBS Volume ARN
output "ebs_volume_arn" {
  value = aws_ebs_volume.my_ebs_volume.arn
}

# EBS Volume Name
output "ebs_volume_name" {
  value = aws_ebs_volume.my_ebs_volume.tags["Name"]
}

# EBS Volume Size
output "ebs_volume_size" {
  value = aws_ebs_volume.my_ebs_volume.size
}

# EBS Volume Type
output "ebs_volume_type" {
  value = aws_ebs_volume.my_ebs_volume.type
}

# EBS Volume Availability Zone
output "ebs_volume_availability_zone" {
  value = aws_ebs_volume.my_ebs_volume.availability_zone
}

# EBS Volume Encryption
output "ebs_volume_encrypted" {
  value = aws_ebs_volume.my_ebs_volume.encrypted
}


# --------------------------------------------------
# EBS Volume Attachment Outputs
# --------------------------------------------------

# Attachment ID
output "ebs_attachment_id" {
  value = aws_volume_attachment.ebs_attachment.id
}

# Attached EC2 Instance ID
output "attached_instance_id" {
  value = aws_volume_attachment.ebs_attachment.instance_id
}

# Attached EBS Volume ID
output "attached_volume_id" {
  value = aws_volume_attachment.ebs_attachment.volume_id
}

# Device Name
output "ebs_attachment_device_name" {
  value = aws_volume_attachment.ebs_attachment.device_name
}
