
# --------------------------------------------------
# Step 1: Generate SSH Private and Public Keys
# --------------------------------------------------

resource "tls_private_key" "key_gen_using_terraform" {

  algorithm = "RSA"

  rsa_bits = 4096

}


# --------------------------------------------------
# Step 2: Upload Generated Public Key to AWS
# --------------------------------------------------

resource "aws_key_pair" "key_gen_using_terraform" {

  key_name = var.key_name

  public_key = tls_private_key.key_gen_using_terraform.public_key_openssh

  tags = {
    Name = var.key_name
  }

}
