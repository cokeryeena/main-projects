output "website_endpoint" {
  description = "Public URL of the static website"
  value       = aws_s3_bucket.static_site.website_endpoint
}
