
output "key_pair_name" {
  description = "AWS Key Pair Name"
  value       = aws_key_pair.my_key.key_name
}

output "key_pair_id" {
  description = "AWS Key Pair ID"
  value       = aws_key_pair.my_key.id

}
