output "acm_website_cert_id" {
  value = aws_acm_certificate.website_cert.id
  sensitive   = false
  description = "ARN of the certificate -but its called id-"
}

output "acm_website_arn" {
  value = aws_acm_certificate.website_cert.arn
  sensitive   = false
  description = "ARN of the certificate"
}

output "acm_website_domain_name" {
  value = aws_acm_certificate.website_cert.domain_name
  sensitive   = false
  description = "Domain name for which the certificate is issued"
}

output "acm_website_certificate_status" {
  value = aws_acm_certificate.website_cert.status
  sensitive   = false
  description = "Status of the certificate."
}

output "acm_website_certificate_type" {
  value = aws_acm_certificate.website_cert.type
  sensitive   = false
  description = "Status of the certificate."
}
