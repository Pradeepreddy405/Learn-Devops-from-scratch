# Output Details of the Key Pair

# Key Pair Name Tag
output "key_pair_name_tag" {
  value = aws_key_pair.my_key.tags["Name"]
}

# Key Pair ID
output "key_pair_id" {
  value = aws_key_pair.my_key.key_pair_id
}

# Key Pair Name
output "key_pair_name" {
  value = aws_key_pair.my_key.key_name
}

# Key Pair ARN
output "key_pair_arn" {
  value = aws_key_pair.my_key.arn
}

# Key Fingerprint
output "key_fingerprint" {
  value = aws_key_pair.my_key.fingerprint
}

# Public Key
output "public_key" {
  value = aws_key_pair.my_key.public_key
}

# Resource Tags
output "key_pair_tags" {
  value = aws_key_pair.my_key.tags
}

# All Tags
output "key_pair_tags_all" {
  value = aws_key_pair.my_key.tags_all
}