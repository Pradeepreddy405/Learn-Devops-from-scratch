
# ------------------------------------------
# Create EC2 Instances using count
# ------------------------------------------

resource "aws_instance" "my_ec2" {

  ami           = var.ami_id
  instance_type = var.instance_type

  count = var.instance_count

  tags = {
    Name = "${var.instance_name}-${count.index}"
  }
}
