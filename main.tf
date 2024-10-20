# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Replace with your desired region
}

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a subnet
resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a" # Specify your preferred AZ
}

# Create a security group to allow necessary traffic (HTTP)
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id
  name   = "my-cricbuzz-security-group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all incoming traffic for now (adjust later for security)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outgoing traffic for now (adjust later for security)
  }
}

# Create an EC2 instance
resource "aws_instance" "my_ec2_instance" {
  ami                    = "ami id" # Replace with your desired AMI ID
  instance_type         = "t2.micro"
  key_name              = "docker" # Ensure this key pair exists
  subnet_id             = aws_subnet.my_subnet.id
  vpc_security_group_ids    = ["vpc_security_group"] # Use security_group_ids instead

  user_data = <<EOF
#!/bin/bash

# Install Docker
sudo apt update
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker

# Clone your Git repository
git clone https://github.com/anushreddydasari/empty.git /var/www/html

# Run your Docker container
docker run -d -p 80:80 --name cricbuzz-app -v /var/www/html:/app anush777/cricbuzz-static:latest
EOF

  tags = {
    Name = "My Cricbuzz Project EC2 Instance"
    Environment = "production"
  }
}
