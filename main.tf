terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_key_pair" "my_ec2_key_pair" {
  key_name   = "mykey"
  public_key = file("mykey.pem")
}

resource "aws_instance" "my_ec2_instance" {
  count         = 1
  ami           = "ami-0f34c5ae932e6f0e4"
  instance_type = "t2.micro"
  user_data     = file("to_execute.sh")

  tags = {
    Name = "JustMonitorInstance"
  }

  # Configure the security group to allow incoming HTTP (port 8080) traffic
  vpc_security_group_ids = [aws_security_group.my_ec2_security_group.id]

  key_name = aws_key_pair.my_ec2_key_pair.key_name

  depends_on = [aws_security_group.my_ec2_security_group]
}

# Create a security group allowing all inbound and outbound traffic
resource "aws_security_group" "my_ec2_security_group" {
  name        = "MyEC2SecurityGroup"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MyEC2SecurityGroup"
  }
}


