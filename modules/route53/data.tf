data "aws_route53_zone" "selected" {
  name         = var.hosted_zone
  private_zone = var.is_private
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = "www.${data.aws_route53_zone.selected.name}"
#   type    = "A"
#   ttl     = "300"
#   records = ["10.0.0.1"]
# }
