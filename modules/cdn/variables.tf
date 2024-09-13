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

variable "s3_origin_path" {
  type = string
  default = "build/"
  description = "Identifier for the CloudFront Origin Access Control"
}

variable "cdn_comment" {
  type = string
  description = "A mandatory comment to identify the CDN distribution"
}

variable "cdn_origin_access_control_name" {
  type = string
  description = "Identifier for the CloudFront Origin Access Control"
}

variable "cdn_origin_access_control_comment" {
  type = string
  description = "Identifier for the CloudFront Origin Access Control"
}

variable "country_blacklist" {
  type = list(string)
  # https://en.wikipedia.org/wiki/List_of_ISO_3166_country_codes
  default = ["CN", "RU", "PK", "IN", "KP" ]
  description = "A list of countries to blacklist, in the form of "
}
