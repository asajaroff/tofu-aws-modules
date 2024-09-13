output "acm_website_cert_id" {
  value = aws_acm_certificate.this.id
  sensitive   = false
  description = "ARN of the certificate -but its called id-"
}

output "acm_website_arn" {
  value = aws_acm_certificate.this.arn
  sensitive   = false
  description = "ARN of the certificate"
}

output "acm_website_domain_name" {
  value = aws_acm_certificate.this.domain_name
  sensitive   = false
  description = "Domain name for which the certificate is issued"
}

output "acm_website_certificate_status" {
  value = aws_acm_certificate.this.status
  sensitive   = false
  description = "Status of the certificate."
}

output "acm_website_certificate_type" {
  value = aws_acm_certificate.this.type
  sensitive   = false
  description = "Status of the certificate."
}
