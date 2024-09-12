variable "region" {
  type = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "s3_bucket_id" {
  type = string
  default = "bucket-name"
  description = "The bucket name for the S3 origin."
}

variable "s3_bucket_regional_domain_name" {
  type = string
  default = ""
  description = "Regional domain name for the target bucket."
}

variable "cdn_name" {
  type = string
  default = "website_in_s3"
  description = "A name for the CDN distribution"
}

variable "cdn_comment" {
  type = string
  default = "For a website deployed in S3"
  description = "A comment for the CDN distribution"
}
