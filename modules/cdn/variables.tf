variable "top_level_domain_name" {
  type = string
  description = <<EOT
Top level domain name, written as 'domain.example.com.'
Will be used to fetch the hosted zone id.
EOT
}

variable "domain_name" {
  type = string
  description = "Domain name for the site, do not include the top level domain"
}

variable "description" {
  type = string
  description = "Description of the CDN distribution to be created"
}

variable "region" {
  type = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "environment" {
  type = string
  description = "'prod' or 'non-prod'"
}

variable "aliases" {
  type = string
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
}

variable "s3_bucket_id" {
  type = string
  default = "bucket-name"
  description = "The bucket name for the S3 origin."
}

variable "s3_bucket_regional_domain_name" {
  type = string
  description = "Regional domain name for the target bucket."
}

variable "mount_cloudfront_default_certificate" {
  type = bool
  default = false
  description = "Wether to mount CloudFront DNS certificate -for development-"
}

variable "s3_origin_path" {
  type = string
  default = ""
  description = "Path to the folder, if any, where the site is located"
}

# variable "cdn_origin_access_control_name" {
#   type = string
#   description = "Identifier for the CloudFront Origin Access Control"
# }

# variable "cdn_origin_access_control_comment" {
#   type = string
#   description = "Identifier for the CloudFront Origin Access Control"
# }

variable "country_blacklist" {
  # https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
  type = list(string)
  default = ["CN", "RU", "PK", "IN", "KP" ]
  description = "A list of countries to blacklist, in the form of "
}

variable "aws_acm_certificate_arn" {
  type = string
  description = "An ARN for a certificate, it must be created on the 'us-east-1' region."
}
