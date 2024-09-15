variable "bucket_name" {
  type        = string
  default     = ""
  description = "Name of the bucket. If omitted, Terraform will assign a random, unique name. Must be lowercase and less than or equal to 63 characters in length"
}

variable "bucket_prefix" {
  type        = string
  description = "Creates a unique bucket name beginning with the specified prefix"
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Wheather to force the destruction of this bucket even if it has objects."
}

variable "versioning" {
  type        = bool
  default     = false
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state."
}

variable "block_public_access" {
  type        = bool
  default     = false
  description = "If true, will create a block for S3 bucket-level Public Access Block configuration"
}

variable "region" {
  type        = string
  description = "Region where the AWS provider will be configured and deployed"
}
