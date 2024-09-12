output "s3_bucket_id" {
  value       = aws_s3_bucket.bucket.id
  description = "The id of the bucket hosting the site files."
}

output "s3_bucket_arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "The ARN of the bucket hosting the site files."
  sensitive = true
}
output "s3_bucket_regional_domain_name" {
  value       = aws_s3_bucket.bucket.bucket_regional_domain_name
  description = "S3 bucket regional domain name."
  sensitive = false
}