variable "name" {
  type = string
  description = "The bucket name, which must be unique across all AWS resources."
}

variable "region" {
  type = string
  description = "Region where the AWS provider will be configured and deployed"
}

variable "force_destroy" {
  type = bool
  default = false
  description = "Wheather to force the destruction of this bucket even if it has objects."
}

variable "versioning" {
  type = bool
  default = true
  description = "Enable versioning. Once you version-enable a bucket, it can never return to an unversioned state."
}

variable "block_public_access" {
  type = bool
  default = false
  description = "If true, will create a block for S3 bucket-level Public Access Block configuration"
}
