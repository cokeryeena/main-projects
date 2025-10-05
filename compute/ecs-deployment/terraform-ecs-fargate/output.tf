output "alb_dns_name" {
  description = "ALB DNS name"
  value       = aws_lb.alb.dns_name
}

output "ecr_repo_uri" {
  description = "ECR repository URI"
  value       = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}
