variable "name" {
  type        = string
  description = "Name tag for the Elastic IP"
}

variable "domain" {
  type        = string
  default     = "vpc"
  description = "Indicates if this EIP is for use in VPC (vpc) or EC2-Classic (standard)"

  validation {
    condition     = contains(["vpc", "standard"], var.domain)
    error_message = "Domain must be either 'vpc' or 'standard'."
  }
}

variable "instance_id" {
  type        = string
  default     = null
  description = "EC2 instance ID to associate with the EIP. Conflicts with network_interface_id"
}

variable "network_interface_id" {
  type        = string
  default     = null
  description = "Network interface ID to associate with the EIP. Conflicts with instance_id"
}

variable "associate_with_private_ip" {
  type        = string
  default     = null
  description = "User-specified primary or secondary private IP address to associate with the EIP"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags for the Elastic IP"
}
