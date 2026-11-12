
# Create AWS Key Pair
resource "aws_key_pair" "my_key" {
  key_name   = "my-terraform-key"
  public_key = file(pathexpand("~/.ssh/terraform-key.pub"))

  # terraform-key.pub is the public key file generated using ssh-keygen command. Make sure to generate the key pair before running terraform apply command.

  tags = {
    Name        = "my-terraform-key"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}

# Output Details of the Key Pair

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
