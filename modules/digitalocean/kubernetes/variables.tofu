# variables.tf
variable "tags" {
  default = {}
  type    = map(string)
}

variable "name" {
  type        = string
  default     = "tofu-aws-modules-tests"
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

variable "hosted_zone" {
  type        = string
  default     = ""
  description = "AWS Hosted Zone"
}

variable "create_example_app" {
  type        = bool
  default     = false
  description = "Whether to create an example app with ingress"
}

variable "example_app_hostname" {
  type        = string
  default     = "example.yourdomain.com"
  description = "Hostname for the example app ingress"
}

variable "letsencrypt_email" {
  type        = string
  default     = "galeira@pm.me"
  description = "Email address for Let's Encrypt ACME registration"
}

variable "letsencrypt_server" {
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  description = "Let's Encrypt ACME server URL (use staging for testing: https://acme-staging-v02.api.letsencrypt.org/directory)"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for Route53"
}
