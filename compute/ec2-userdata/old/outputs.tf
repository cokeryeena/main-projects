output "instance_id" {
  description = "i-07b8ac0a3db513940"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "34.229.209.44"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "ec2-34-229-209-44.compute-1.amazonaws.com"
  value       = aws_instance.web.public_dns
}
