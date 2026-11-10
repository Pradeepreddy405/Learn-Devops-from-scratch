resource "aws_instance" "you_can_specify_name_of_instance_or_purpose_of_instance" {

  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Your first Ec2 instance - Congratulations you did it buddy"
  }
}