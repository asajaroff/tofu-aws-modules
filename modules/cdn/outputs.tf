output cloudfront_name {
  value       = aws_cloudfront_distribution.s3_distribution.domain_name
  sensitive   = false
  description = "DNS name of the target Cloudfront distribution for the website."
}

output cloudfront_zone_id {
  value       = aws_cloudfront_distribution.s3_distribution.id
  sensitive   = false
  description = "Cloudfront distribution ID for the alias of the website."
}

output cloudfront_https_url {
  value = "https://${aws_cloudfront_distribution.s3_distribution.domain_name}"
  sensitive = false
  description = "URL of the CloudFront distribution, for testing purposes."
}
