# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone#argument-reference
data "aws_route53_zone" "selected" {
  name         = var.top_level_domain_name
  private_zone = false
}

# https://registry.terraform.io/providers/hashicorp/aws/5.67.0/docs/resources/acm_certificate
resource "aws_acm_certificate" "this" {
  domain_name               = "${var.domain_name}.${var.top_level_domain_name}"
  subject_alternative_names = ["*.${var.domain_name}.${var.top_level_domain_name}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation
# resource "aws_acm_certificate_validation" "cert" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [aws_route53_record.base_domain.record.fqdn]
# }
resource "aws_route53_record" "dns_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
  # validation_record_fqdns = [for record in aws_route53_record.dns_validation_records : record.fqdn]
}
