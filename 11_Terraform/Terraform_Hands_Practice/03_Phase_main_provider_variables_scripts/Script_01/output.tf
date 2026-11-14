
# Output Details

output "Instance_name" {
  description = "EC2 Instance Name"
  value       = aws_instance.nginx_web_server.tags["Name"]
}

output "Instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.nginx_web_server.id
}

output "Public_ip" {
  description = "Public IP Address"
  value       = aws_instance.nginx_web_server.public_ip
}

output "Private_ip" {
  description = "Private IP Address"
  value       = aws_instance.nginx_web_server.private_ip
}

output "Availability_zone" {
  description = "Availability Zone"
  value       = aws_instance.nginx_web_server.availability_zone
}

output "ec2_public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.nginx_web_server.public_dns
}

output "machine_hostname" {
  description = "OS-level machine hostname"
  value       = split(".", aws_instance.nginx_web_server.private_dns)[0]
}
