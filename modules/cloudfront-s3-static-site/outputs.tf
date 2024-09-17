output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.static_site.id
  sensitive   = false
  description = "ID of the CloudFront distribution"
}

output "cloudfront_distribution_domain_name" {
  value       = aws_cloudfront_distribution.static_site.domain_name
  sensitive   = false
  description = "Domain name for the CloudFront distribution"
}
