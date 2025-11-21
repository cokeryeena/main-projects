provider "aws" {
  region = "us-east-1"
}

# S3 bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "coker-iam-upload-test"
  acl    = "private"
}

# IAM role for EC2
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2-s3-upload-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# IAM policy for S3 access
resource "aws_iam_policy" "s3_upload_policy" {
  name        = "s3-upload-policy"
  description = "Allow EC2 to upload objects to S3 bucket"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:PutObject", "s3:ListBucket"]
      Effect   = "Allow"
      Resource = [
        aws_s3_bucket.test_bucket.arn,
        "${aws_s3_bucket.test_bucket.arn}/*"
      ]
    }]
  })
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_upload_policy.arn
}

# EC2 instance with IAM role
resource "aws_instance" "ec2" {
  ami           = "ami-00ca32bbc84273381"
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello S3!" > /tmp/testfile.txt
              aws s3 cp /tmp/testfile.txt s3://${aws_s3_bucket.test_bucket.bucket}/testfile.txt
              EOF

  tags = {
    Name = "s3-upload-test-instance"
  }
}

# IAM profile (required for EC2 role)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-s3-profile"
  role = aws_iam_role.ec2_s3_role.name
}
