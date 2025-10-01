provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t3.micro"
  key_name      = "cokerkeypair" 

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "CleanEC2"
  }
}
