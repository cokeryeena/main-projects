# Serverless Automation using AWS Lambda

## Overview
This project demonstrates a **serverless compute workflow** using AWS Lambda, triggered by S3 events. When an image is uploaded to an S3 bucket, Lambda automatically resizes it and stores the result in another bucket.

## Tech Stack
- AWS Lambda
- AWS S3
- Terraform (Infrastructure as Code)
- Python (Pillow for image processing)

## Architecture
1. Image uploaded to **Source Bucket**
2. S3 triggers **Lambda function**
3. Lambda resizes image
4. Output saved in **Destination Bucket**

## Deployment
```bash
cd terraform
terraform init
terraform apply

## Screenshots
- [Lambda Apply](screenshots/lambda-apply)
- [S3 Bucket](screenshots/s3-bucket)
- [Lambda Function](screenshots/lambda-function)
