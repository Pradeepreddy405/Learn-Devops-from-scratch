
output "key_pair_name" {
  description = "AWS Key Pair Name"
  value       = aws_key_pair.key_gen_using_terraform.key_name
}

output "key_pair_id" {
  description = "AWS Key Pair ID"
  value       = aws_key_pair.key_gen_using_terraform.id
}

output "public_key" {
  description = "Generated Public Key"
  value       = tls_private_key.key_gen_using_terraform.public_key_openssh
}

output "private_key" {
  description = "Generated Private Key"
  value       = tls_private_key.key_gen_using_terraform.private_key_pem
  sensitive   = true
}
