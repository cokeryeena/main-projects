terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1" 
}

# Dynamically fetch the latest Amazon Linux 2 AMI 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = "cokerkeypair"   

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name    = "terraform-web-instance"
    Project = "EC2-UserData-Automation"
  }
}
