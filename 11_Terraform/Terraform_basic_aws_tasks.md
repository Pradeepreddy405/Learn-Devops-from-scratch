### Cloud provider info

		provider "aws" {
		region = "us-east-1"
		}
### VPC-Creation
		resource "aws_vpc" "main" {
		cidr_block = "10.0.0.0/16"
		
		tags = {
			Name = "Mr_cloud_vpc"
		}
		}
### Subnet-Creation	

	### Public-subnet
		resource "aws_subnet" "public" {
		vpc_id            = aws_vpc.main.id
		cidr_block        = "10.0.2.0/24"
		availability_zone = "us-east-1a"
		
		tags = {
			Name = "Mr_cloudd_public_subnet"
		}
		}
	### Private-subnet	
		resource "aws_subnet" "private" {
		vpc_id            = aws_vpc.main.id
		cidr_block        = "10.0.3.0/24"
		availability_zone = "us-east-1a"
		
		tags = {
			Name = "Mr_cloud_private_subnet"
		}
		}
### Internet gateway		
		resource "aws_internet_gateway" "igw" {
		vpc_id = aws_vpc.main.id
		
		tags = {
			Name = "Mr_cloud_internet_gateway"
		}
		}
### Routing 		
		resource "aws_route_table" "public_rt" {
		vpc_id = aws_vpc.main.id
		
			route {
				cidr_block = "0.0.0.0/0"
				gateway_id = aws_internet_gateway.igw.id
			}
		
			tags = {
				Name = "Mr_cloud_public_route_table"
			}
		}
### Subnet association with route table
	
		resource "aws_route_table_association" "public_assoc" {
		subnet_id      = aws_subnet.public.id
		route_table_id = aws_route_table.public_rt.id
		}
		
### Security group and Ec2-instance Creation

		resource "aws_security_group" "web_sg" {
		name        = "web-sg"
		description = "Allow SSH and HTTP"
		vpc_id      = aws_vpc.main.id
		
		ingress {
			description = "SSH"
			from_port   = 22
			to_port     = 22
			protocol    = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}
		
		ingress {
			description = "HTTP"
			from_port   = 80
			to_port     = 80
			protocol    = "tcp"
			cidr_blocks = ["0.0.0.0/0"]
		}
		
		egress {
			from_port   = 0
			to_port     = 0
			protocol    = "-1"
			cidr_blocks = ["0.0.0.0/0"]
		}
		
		tags = {
			Name = "web-sg"
		}
		}
		
		resource "aws_instance" "web" {
		ami                    = "ami-0532be01f26a3de55" # Example AMI
		instance_type          = "t2.micro"
		subnet_id              = aws_subnet.public.id
		vpc_security_group_ids = [aws_security_group.web_sg.id]
		key_name               = "Minikube_setup"
		iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
		
		}
		
### S3-Bucket-Creation		
		resource "aws_s3_bucket" "demo_bucket" {
		bucket = "mr-cloud-bucket-989"
		
		tags = {
			Name = "Mr_cloud_storage"
		}
		}
### Ec2-instance-profile-creation-s3-access		
		resource "aws_iam_role" "ec2_role" {
		name = "ec2-s3-role"
		
		assume_role_policy = jsonencode({
			Version = "2012-10-17"
			Statement = [{
			Effect = "Allow"
			Principal = {
				Service = "ec2.amazonaws.com"
			}
			Action = "sts:AssumeRole"
			}]
		})
		}
		
		
		resource "aws_iam_policy" "s3_read_policy" {
		name = "s3-read-policy"
		
		policy = jsonencode({
			Version = "2012-10-17"
			Statement = [{
			Effect   = "Allow"
			Action   = ["s3:GetObject", "s3:ListBucket"]
			Resource = [
				aws_s3_bucket.demo_bucket.arn,
				"${aws_s3_bucket.demo_bucket.arn}/*"
			]
			}]
		})
		}
		
		resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
		role       = aws_iam_role.ec2_role.name
		policy_arn = aws_iam_policy.s3_read_policy.arn
		}
		
		resource "aws_iam_instance_profile" "ec2_profile" {
		name = "ec2-instance-profile"
		role = aws_iam_role.ec2_role.name
		}
		
		