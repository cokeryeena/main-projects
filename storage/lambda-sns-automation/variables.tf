variable "region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
  default     = "s3-to-sns-lambda"
}

variable "sns_topic_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = "s3-events-topic"
}
