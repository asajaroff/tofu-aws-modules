# variables.tf
variable "tags" {
  default = {}
  type    = map(string)
}

variable "name" {
  type        = string
  default     = "tofu-modules-tests"
  description = "Name for the VPC"
}

variable "region" {
  type        = string
  default     = "ams3"
  description = "Region where the VPC will be deployed"
}

variable "do_token" {
  type        = string
  description = "Token"
}
