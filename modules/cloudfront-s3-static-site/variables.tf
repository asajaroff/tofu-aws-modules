variable "s3_bucket_name" {
  type        = string
  description = "Name of the S3 bucket that will be created to store the static site content"
}

variable "site_fqdn" {
  type        = string
  description = <<EOT
Fully qualified domain name (FQDN) that will be used to access the static site.
ACM Certificates will be created for this domain and the CloudFront distribution will be configured to use them.
The form is `example.com` or `subdomain.example.com`.
EOT
}

variable "top_level_domain" {
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
  description = "Whether the environment is production or not"
}


variable "site_deploy_folder" {
  type        = string
  default     = "public/"
  description = <<EOT
The Cloudfront distribution will be configured to serve content from this folder within the S3 bucket.
A valid value is `public/` or `site/`.
EOT
}
