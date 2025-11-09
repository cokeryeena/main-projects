provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with website configuration
resource "aws_s3_bucket" "static_site" {
  bucket = "coker-static-website-bucket"

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = {
    Name        = "S3 Static Website"
    Environment = "Dev"
  }
}

# Allow public access to the bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.static_site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Add a bucket policy for public read access
resource "aws_s3_bucket_policy" "public_read_policy" {
  depends_on = [aws_s3_bucket_public_access_block.public_access]

  bucket = aws_s3_bucket.static_site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site.arn}/*"
      }
    ]
  })
}

# Upload site files to S3
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.static_site.bucket
  key          = "error.html"
  source       = "${path.module}/error.html"
  content_type = "text/html"
}
