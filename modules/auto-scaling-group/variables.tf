variable "tags" {
  default = {}
  type    = map(string)
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where the AWS provider will be configured and deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC where the resources will be created"
}
