
output "ec2_instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.my_ec2.id
}

output "ec2_instance_name" {
  description = "EC2 instance name"
  value       = aws_instance.my_ec2.tags["Name"]
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "monitoring_enabled" {
  description = "EC2 detailed monitoring status"
  value       = aws_instance.my_ec2.monitoring
}
