output "cloudfront_name" {
  value       = aws_cloudfront_distribution.this.domain_name
  sensitive   = false
  description = "DNS name of the target Cloudfront distribution for the website."
}

output "cloudfront_zone_id" {
  value       = aws_cloudfront_distribution.this.id
  sensitive   = false
  description = "Cloudfront distribution ID for the alias of the website."
}

output "cloudfront_https_url" {
  value       = "https://${aws_cloudfront_distribution.this.domain_name}"
  sensitive   = false
  description = "URL of the CloudFront distribution, for testing purposes."
}

output "route53_record_name" {
  value = aws_route53_record.base_domain.name
}

output "route53_record_fqdn" {
  value = aws_route53_record.base_domain.name
}
