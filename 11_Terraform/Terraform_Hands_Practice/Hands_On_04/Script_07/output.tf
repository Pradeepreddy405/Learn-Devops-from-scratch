output "availability_zone" {
  description = "EBS Volume Availability Zone"
  value       = aws_ebs_volume.my_ebs.availability_zone
}

output "region" {
  description = "EBS Volume Region"
  value       = aws_ebs_volume.my_ebs.region
}

output "ebs_volume_name" {
  description = "EBS Volume Name"
  value       = aws_ebs_volume.my_ebs.tags["Name"]
}

output "ebs_volume_id" {
  description = "EBS Volume ID"
  value       = aws_ebs_volume.my_ebs.id
}

output "ebs_volume_size" {
  description = "EBS Volume Size"
  value       = aws_ebs_volume.my_ebs.size
}

output "ebs_volume_type" {
  description = "EBS Volume Type"
  value       = aws_ebs_volume.my_ebs.type
}