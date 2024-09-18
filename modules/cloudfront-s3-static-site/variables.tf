variable "s3_origin_path" {
  type        = string
  default     = "/public"
  description = <<-EOT
  None
  EOT
}

variable "s3_bucket_versioning" {
  type        = bool
  description = "Enable versioning on the S3 bucket"
}

variable "s3_bucket_name" {
  type        = string
  default     = "bucket-name"
  description = "Name of the S3 bucket that will be created to store the static site content"
}

variable "subdomain" {
  type        = string
  default     = ""
  description = <<-EOT
  Subdomain of the site.
  EOT
}

variable "hosted_zone_domain_name" {
  type        = string
  default     = "example.com."
  description = "Top level domain of the site, written with a trailing dot: \"example.com.\""
}

variable "region" {
  type        = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "extra_tags" {
  type        = map(string)
  default     = {
    "Environment" = "Development"
    "Terragrunt"  = "false"
  }
  description = "Extra tags to be added to the resources created by this module"
}

variable "is_prod" {
  type        = bool
  default    = false
  description = <<-EOT
  If true, will enable Bucket Versioning and Bucket Logging.
  EOT
}
