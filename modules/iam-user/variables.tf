variable "tags" {
  default = {}
  type    = map(string)
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Region where the AWS provider will be configured and deployed"
}

variable "user_name" {
  type        = string
  description = "The IAM user name"
}

variable "user_description" {
  type        = string
  description = "Description of the user"
}

variable "policy_description" {
  type        = string
  description = "Description of the IAM policy that will be created"
}
