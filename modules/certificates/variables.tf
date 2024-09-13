variable "top_level_domain_name" {
  type = string
  description = <<EOT
Top level domain name, written as 'domain.example.com.'
Will be used to fetch the hosted zone id.
EOT
}

variable "domain_name" {
  type = string
  description = <<EOT
Final domain name of the certificate.
A DNS record for "www.$\{value\}" will be also created.
EOT
}

variable "alias_cloudfront_zone_id" {
  type = string
  default = "Z2FDTNDATAQYW2"
  description = <<EOT
CloudFront distribution hosted zone ID.
This value must not be changed when using CloudFront domain for development.
EOT
}

variable "environment" {
  type = string
  default = "non-prod"
  description = "Environment, used to 'allow_overwrite' on DNS records or not."
}
