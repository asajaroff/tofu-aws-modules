output "bucket_id" {
  value       = aws_s3_bucket.this.id
  description = "Name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.this.arn
  description = "ARN of the bucket. Will be of format arn:aws:s3:::bucketname"
  sensitive   = true
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "S3 bucket regional domain name."
  sensitive   = false
}

output "bucket_website_fqdn" {
  value       = "${aws_s3_bucket.this.bucket_regional_domain_name}/public/index.html"
  description = "Index document for the bucket"
  sensitive   = false
}

output "bucket_website_index" {
  value       = "${aws_s3_bucket.this.bucket_regional_domain_name}/public/index.html"
  description = "Index document for the bucket"
  sensitive   = false
}

output "hosted_zone_id" {
  value       = aws_s3_bucket.this.hosted_zone_id
  description = "Route 53 Hosted Zone ID for this bucket's region"
}
