# aws_route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone#argument-reference
data "aws_route53_zone" "selected" {
  name         = var.domain_name
  private_zone = false
}

# route53_record
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "base_domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "${data.aws_route53_zone.selected.name}"
  type    = "A"

  alias {
    name = var.alias_cloudfront_name
    zone_id = var.alias_cloudfront_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${data.aws_route53_zone.selected.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${data.aws_route53_zone.selected.name}"]
}

resource "aws_route53_record" "base_domain_ipv6" {
  # ToDo try() function
  # zone_id         = try(data.aws_route53_zone.selected.zone_id, "")
  zone_id         = data.aws_route53_zone.selected.zone_id
  name            = "${data.aws_route53_zone.selected.name}"
  allow_overwrite = var.environment != "prod" ? true : false
  type            = "AAAA"

  alias {
    name = var.alias_cloudfront_name
    zone_id = var.alias_cloudfront_zone_id
    evaluate_target_health = true
  }
}

# aws_acm_certificate reference
# https://registry.terraform.io/providers/hashicorp/aws/5.67.0/docs/resources/acm_certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  subject_alternative_names = []
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}
