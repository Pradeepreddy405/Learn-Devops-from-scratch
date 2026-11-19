
resource "aws_key_pair" "my_key" {

  key_name = var.key_name

  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = var.key_name
  }
}
