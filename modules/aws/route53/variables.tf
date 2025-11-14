variable "hosted_zone" {
  type        = string
  description = "Top level domain for the hosted zone, either 'example.com' or 'subdomain.example.com'"
}

variable "is_private" {
  type        = bool
  default     = "false"
  description = "Boolean to check if the target hosted zone is private"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where the AWS provider will be configured and deployed"
}

variable "target" {
  type        = string
  default     = "us-east-1"
  description = "List of IP Addresses to include"
}

variable "record_type" {
  type        = string
  default     = "A"
  description = "Type of Registry"
}

variable "ttl" {
  type        = number
  default     = "3600"
  description = "TTL of the entry"
}
