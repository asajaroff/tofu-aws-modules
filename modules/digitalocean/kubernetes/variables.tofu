variable "tags" {
  default = {}
  type    = map(string)
}

variable "name" {
  type        = string
  default     = "development-ar-do-ams3"
  description = "Name for the Kubernetes cluster"
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
  description = <<EOD
The AWS hosted zone ID in Route53 where the domain controlled by cert-manager lives.
EOD
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
  description = "Email address for Let's Encrypt ACME registration"
}

variable "letsencrypt_server_prod" {
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
  description = "Let's Encrypt ACME server URL (use staging for testing: https://acme-staging-v02.api.letsencrypt.org/directory)"
}

variable "letsencrypt_server_staging" {
  type        = string
  default     = "https://acme-staging-v02.api.letsencrypt.org/directory"
  description = "Let's Encrypt ACME server URL -staging-"
}

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region for Route53"
}

variable "gitea_admin_username" {
  type        = string
  default     = "galera"
  description = "Gitea admin username"
}

variable "gitea_admin_password" {
  type        = string
  sensitive   = true
  description = "Gitea admin password"
}

variable "gitea_admin_email" {
  type        = string
  description = "Gitea admin email address"
}
