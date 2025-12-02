# Main Projects Monorepo

 Welcome to my DevOps Main Projects Monorepo, a single home for hands-on AWS, Linux, Bash, and automation projects.
 This repo is structured for learning,breaking and fixing, documentation, and showcasing real-world cloud engineering skills.

## Repository Structure
main-projects/

**compute/
- autoscaling-webapp/
- cicd-pipeline/
- ec2-userdata/ 
- ec2-deployment/
- lambda-image-resize/
       

**storage/
- iam-upload/
- s3-lambda-sns-automation/
- s3-static-website/
       



## Each folder contains:

A dedicated README explaining the project

Scripts, Terraform configuration, or assets

Clear documentation of steps, architecture, and testing


## What’s Inside?

# 1. Compute Projects

Focused on:

- EC2 provisioning

- User data scripts

- Web server deployments

- Lambda automations

- IAM roles & permissions

- Terraform infrastructure as code

These projects show the fundamentals every cloud engineer should know

# 2. Storage Projects

Covers:

- S3 bucket setup

- Public & private access patterns

- IAM policies for uploads

- Static website hosting

- Event-driven automation with S3 → Lambda → SNS

- Security best practices

# 3. Network Projects

- Public subnet (Internet access via IGW)
- Private subnet (Outbound access via NAT)
- Bastion host (SSH entry point to private EC2)
- Security groups enforce least-privilege access
- Terraform Structure


## Technologies Used

- AWS (EC2, S3, Lambda, IAM, CloudWatch, SNS, VPC)

- Terraform (IAC for reproducible setups)

- Bash scripting

- Linux server administration

- Git & GitHub

- Python (for Lambda functions)

## How to Use This Monorepo

Follow the README for each project

Each project is self-contained and explains:

- Architecture

- Process

- Setup steps

- Testing

- Screenshots

## Why a Monorepo?

- Keeps all my projects in one clean place

- Makes navigation easier

- Consistent documentation



## Future Improvements

- Add CI/CD pipelines for every projects

- Add automated tests where possible

- Expand to networking and security projects

## Contributions
This repo is mainly for personal learning and documentation.
Pull requests and improvements are welcome.
