variable "s3_origin_path" {
  type        = string
  default     = "/public"
  description = <<EOT
The Cloudfront distribution will be configured to serve content from this folder within the S3 bucket.
A valid value is '/public' or ''. If the value is '', the root of the bucket will be served.
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/distribution-web-values-specify.html#DownloadDistValuesOriginPath
EOT
}

variable "s3_bucket_versioning" {
  type        = bool
  description = "Enable versioning on the S3 bucket"
}

variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket that will be created to store the static site content"
}

variable "subdomain" {
  type        = string
  description = <<EOT
Subdomain of the site. If the site is hosted at www.example.com, the subdomain is www.
If it is an enpty string, the site will be hosted at the root of the domain.
An additional 'www.' record will be created.
EOT
}

variable "hosted_zone_domain_name" {
  type        = string
  description = "Top level domain of the site"
}

variable "region" {
  type        = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "extra_tags" {
  type        = map(string)
  description = "Extra tags to be added to the resources created by this module"
}

variable "is_prod" {
  type        = bool
  default    = false
  description = <<EOT
If true, will enable Bucket Versioning and Bucket Logging.
EOT
}
