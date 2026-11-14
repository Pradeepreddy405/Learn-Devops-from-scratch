
# Create EC2 Instance

resource "aws_instance" "nginx_web_server" {
  ami           = "ami-0c230065b91270bc6"
  instance_type = "t3.micro"

  tags = {
    Name = "Nginx Web Server"
  }
}
