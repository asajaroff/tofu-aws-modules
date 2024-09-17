data "aws_route53_zone" "selected" {
  name         = var.hosted_zone_domain_name
private_zone = false
}

resource "aws_route53_record" "site" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = var.subdomain != "" ? var.subdomain : ""
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.static_site.domain_name
    zone_id                = aws_cloudfront_distribution.static_site.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "site_www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www.${var.subdomain}"
  type    = "CNAME"
  ttl     = "5"
  records = [ aws_route53_record.site.fqdn ]
}
