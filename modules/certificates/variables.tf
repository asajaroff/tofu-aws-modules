variable "domain_name" {
  type = string
  description = "Base domain name, written as 'domain.example.com.'"
}

variable "alias_cloudfront_name" {
  type = string
  description = "Cloudfront distribution domain name, I suspect"
}

variable "alias_cloudfront_zone_id" {
  type = string
  description = "The Cloudfront Zone ID"
}

variable "environment" {
  type = string
  default = "non-prod"
  description = "Environment, used to 'allow_overwrite' on DNS records or not."
}
