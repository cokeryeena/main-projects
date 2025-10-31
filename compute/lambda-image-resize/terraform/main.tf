provider "aws" {
  region = "us-east-1"
}

# S3 Buckets
resource "aws_s3_bucket" "source_bucket" {
  bucket = "lambda-image-source-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = "lambda-image-destination-bucket-${random_id.suffix.hex}"
  force_destroy = true
}

resource "random_id" "suffix" {
  byte_length = 4
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_image_resize_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Lambda Function
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda"
  output_path = "../lambda.zip"
}

resource "aws_lambda_function" "image_resizer" {
  function_name = "lambda-image-resizer"
  handler       = "handler.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_role.arn
  filename      = data.archive_file.lambda_zip.output_path
  environment {
    variables = {
      DEST_BUCKET = aws_s3_bucket.destination_bucket.bucket
    }
  }
}

# S3 Event Notification
resource "aws_s3_bucket_notification" "bucket_notify" {
  bucket = aws_s3_bucket.source_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_resizer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3]
}

# Lambda Permission for S3 Trigger
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_resizer.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source_bucket.arn
}

output "source_bucket_name" {
  value = aws_s3_bucket.source_bucket.bucket
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination_bucket.bucket
}
