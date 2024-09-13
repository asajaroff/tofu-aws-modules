# aws_route53_zone
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone#argument-reference
data "aws_route53_zone" "selected" {
  name         = var.top_level_domain_name
  private_zone = false
}

# route53_record
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
resource "aws_route53_record" "base_domain" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${data.aws_route53_zone.selected.name}"]
}

resource "aws_route53_record" "base_domain_ipv6" {
  zone_id         = data.aws_route53_zone.selected.zone_id
  name            = var.domain_name
  allow_overwrite = var.environment != "prod" ? true : false
  type            = "AAAA"

  alias {
    name = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}
