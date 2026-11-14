
# ------------------------------------------
# Create Multiple EC2 Instances Using count
# count.index automatically assigns a unique
# index to each EC2 instance.
# ------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t2.micro"

  count = 3

  tags = {
    Name = "Terraform-EC2-${count.index}"
  }
}
