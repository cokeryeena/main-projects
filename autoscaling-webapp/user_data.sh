#!/bin/bash
# Install Docker
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Authenticate Docker to ECR
$(aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin 913617601626.dkr.ecr.us-east-1.amazonaws.com)

# Pull and run the app container
docker pull 913617601626.dkr.ecr.us-east-1.amazonaws.com/flask-webapp:latest
docker run -d -p 80:5000 913617601626.dkr.ecr.us-east-1.amazonaws.com/flask-webapp:latest
