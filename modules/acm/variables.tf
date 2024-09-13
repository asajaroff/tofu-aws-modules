variable "top_level_domain_name" {
  type = string
  description = <<EOT
Top level domain name, written as 'domain.example.com.'
Will be used to fetch the hosted zone id.
EOT
}

variable "domain_name" {
  type = string
  description = <<EOT
Final domain name of the certificate.
A DNS record for "www.$\{value\}" will be also created.
EOT
}
