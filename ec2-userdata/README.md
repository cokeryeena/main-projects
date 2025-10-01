# EC2 User Data Automation (AWS + Terraform)

## Project Overview 
This project provisions an **EC2 instance** in AWS using **Terraform** and bootstraps it with a **User Data script** that:
- Installs Docker
- Starts the Docker service
- Runs an **Nginx container** automatically on port 80

When the instance launches, you can visit its public IP address in a browser and see the **Nginx welcome page** without any manual configuration.

---

## Tools Stack 
- **Terraform** (Infrastructure as Code)
- **AWS EC2** (Compute resource)
- **Amazon Linux 2** (Base AMI)
- **Docker** (Container runtime)
- **Nginx** (Web server container)

---

## Project Structure 
