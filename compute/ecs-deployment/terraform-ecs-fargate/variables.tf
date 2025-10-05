variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "flask-ecs"
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
  default     = "flask-app"
}

variable "image_uri" {
  description = "Full image URI (e.g. 913617601626.dkr.ecr.<region>.amazonaws.com/flask-app:latest )"
  type        = string
  default     = ""
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "flask-ecs-cluster"
}

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "flask-app"
}

variable "container_port" {
  description = "Container port where app listens"
  type        = number
  default     = 5000
}

variable "task_cpu" {
  description = "Task CPU units (Fargate)"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Task memory (MB) (Fargate)"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Initial desired count for service"
  type        = number
  default     = 1
}

variable "health_check_path" {
  description = "ALB health check path"
  type        = string
  default     = "/"
}

variable "autoscale_min" {
  type    = number
  default = 1
}
variable "autoscale_max" {
  type    = number
  default = 3
}
