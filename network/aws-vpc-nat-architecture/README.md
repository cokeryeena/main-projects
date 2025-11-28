# AWS VPC NAT Architecture with Bastion + Private EC2

## Overview
This project demonstrates a professional AWS networking setup using Terraform:

- Custom VPC with public and private subnets
- Internet Gateway for public access
- NAT Gateway for outbound internet access from private subnet
- Bastion host in the public subnet for secure SSH access
- Private EC2 instance in the private subnet
- Proper security groups restricting access
- Automated deployment via Terraform


## Architecture 
- Public subnet → Internet access via IGW
- Private subnet → Outbound access via NAT
- Bastion host → SSH entry point to private EC2
- Security groups enforce least-privilege access


## Terraform Structure
networking/aws-vpc-nat-architecture/
- main.tf (VPC, Subnets, Route Tables, NAT)
- ec2.tf (EC2 Instances (Bastion + Private))
- security.tf (Security Groups)
- keypair.tf (Key Pair)
- variables.tf (Variables)
- outputs.tf (Outputs)
- README.md



## Deployment Steps
1. Initialize Terraform:
```bash
terraform init
terraform plan
terraform apply



## Screenshots 

1. **Terraform apply success** → `terraform apply` output  
![Terraform Apply](apply-tf.png)

2. **AWS Console VPC diagram** → show public/private subnets  
![Subnets](subnets.png)

3. **EC2 instances list** → show bastion + private instance with correct subnet  
![EC2 Instances](aws-instances.png)

4. **SSH into bastion** → screenshot terminal  
![Bastion](ssh-bastion.png)

5. **SSH from bastion → private** 
![Bastion-Private](bastion-private.png)
  
6. **Curl test from private EC2** → screenshot terminal  
![Curl test](curl.png)

