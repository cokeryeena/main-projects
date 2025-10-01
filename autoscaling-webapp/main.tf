provider "aws" {
  region = "us-east-1"
}

# -------------------------
# IAM Role for EC2 to pull from ECR
# -------------------------
resource "aws_iam_role" "ec2_ecr_role" {
  name = "FlaskWebApp-EC2-ECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "ecr_pull_policy" {
  name = "FlaskWebApp-ECRPullPolicy"
  role = aws_iam_role.ec2_ecr_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["ecr:GetAuthorizationToken"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "arn:aws:ecr:us-east-1:913617601626:repository/flask-webapp"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_ecr_profile" {
  name = "FlaskWebApp-InstanceProfile"
  role = aws_iam_role.ec2_ecr_role.name
}

# -------------------------
# Security Group
# -------------------------
resource "aws_security_group" "web_sg" {
  name        = "flask-webapp-sg"
  description = "Allow HTTP inbound"
  vpc_id      = "vpc-00c24b7f87cb3a49b"

  ingress {
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
}

# -------------------------
# Launch Template
# -------------------------
resource "aws_launch_template" "flask_lt" {
  name_prefix   = "flask-webapp-lt"
  image_id      = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ecr_profile.name
  }

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = base64encode(<<EOF
#!/bin/bash
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Authenticate with ECR and run container
TOKEN=$(aws ecr get-login-password --region us-east-1)
docker login -u AWS -p $TOKEN 913617601626.dkr.ecr.us-east-1.amazonaws.com

docker run -d -p 80:5000 913617601626.dkr.ecr.us-east-1.amazonaws.com/flask-webapp:latest
EOF
  )
}

# -------------------------
# Auto Scaling Group + ALB
# -------------------------
resource "aws_lb" "flask_alb" {
  name               = "flask-webapp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = ["subnet-057da978f27fdd053", "subnet-0fc085fde3fb8cbe1"]
}

resource "aws_lb_target_group" "flask_tg" {
  name     = "flask-webapp-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-00c24b7f87cb3a49b"
}

resource "aws_lb_listener" "flask_listener" {
  load_balancer_arn = aws_lb.flask_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.flask_tg.arn
  }
}

resource "aws_autoscaling_group" "flask_asg" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = ["subnet-057da978f27fdd053", "subnet-0fc085fde3fb8cbe1"]

  launch_template {
    id      = aws_launch_template.flask_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.flask_tg.arn]
  health_check_type = "EC2"
}

