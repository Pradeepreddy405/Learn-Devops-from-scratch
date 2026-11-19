
# --------------------------------------------------
# Create an EBS Volume
# --------------------------------------------------

resource "aws_ebs_volume" "my_ebs_volume" {

  availability_zone = "us-east-1a"
  size              = 10
  type              = "gp3"
  encrypted         = true

  tags = {
    Name        = "My EBS Volume"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}


# --------------------------------------------------
# Read EBS Volume Details (Data Source)
# --------------------------------------------------

data "aws_ebs_volume" "existing" {

  filter {
    name   = "volume-id"
    values = [aws_ebs_volume.my_ebs_volume.id]
  }
}


# --------------------------------------------------
# EBS Volume Output Attributes
# --------------------------------------------------

# EBS Volume Name
output "ebs_volume_name" {
  description = "EBS Volume Name"
  value       = aws_ebs_volume.my_ebs_volume.tags["Name"]
}

# EBS Volume ID
output "ebs_volume_id" {
  description = "EBS Volume ID"
  value       = aws_ebs_volume.my_ebs_volume.id
}

# EBS Volume ARN
output "ebs_volume_arn" {
  description = "EBS Volume ARN"
  value       = aws_ebs_volume.my_ebs_volume.arn
}

# EBS Volume Size
output "ebs_volume_size" {
  description = "EBS Volume Size in GiB"
  value       = aws_ebs_volume.my_ebs_volume.size
}

# EBS Volume Type
output "ebs_volume_type" {
  description = "EBS Volume Type"
  value       = aws_ebs_volume.my_ebs_volume.type
}

# Availability Zone
output "ebs_volume_availability_zone" {
  description = "EBS Volume Availability Zone"
  value       = aws_ebs_volume.my_ebs_volume.availability_zone
}

# Encryption Status
output "ebs_volume_encrypted" {
  description = "EBS Encryption Status"
  value       = aws_ebs_volume.my_ebs_volume.encrypted
}

# EBS Volume IOPS
output "ebs_volume_iops" {
  description = "EBS Volume IOPS"
  value       = aws_ebs_volume.my_ebs_volume.iops
}

# EBS Volume Throughput
output "ebs_volume_throughput" {
  description = "EBS Volume Throughput"
  value       = aws_ebs_volume.my_ebs_volume.throughput
}


# EBS Volume Tags
output "ebs_volume_tags" {
  description = "EBS Volume Tags"
  value       = aws_ebs_volume.my_ebs_volume.tags
}

# Snapshot ID
output "ebs_volume_snapshot_id" {
  description = "Snapshot ID used to create the volume"
  value       = aws_ebs_volume.my_ebs_volume.snapshot_id
}
