# resource "aws_s3_bucket_acl" "b_acl" {
#   bucket = aws_s3_bucket.b.id
#   acl    = "private"
# }
resource "aws_cloudfront_origin_access_control" "s3_origin" {
  name                              = substr(var.s3_bucket_id, 0, 40)
  description                       = "${substr(var.s3_bucket_id, 0, 40)} access control policy for S3 origin"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution
resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.description
  default_root_object = "index.html"

  aliases = var.environment != "prod" ? [var.aliases] : []

  # ToDo: Staging distribution
  # staging = var.environment != "prod" ? true : false

  # S3 origin
  origin {
    domain_name              = var.s3_bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_origin.id
    origin_id                = var.s3_bucket_id
    origin_path              = var.s3_origin_path
  }

  # ToDo: add logging
  #  logging_config {
  #    include_cookies = false
  #    bucket          = "mylogs.s3.amazonaws.com"
  #    prefix          = "myprefix"
  #  }

  custom_error_response {
    error_code         = "404"
    response_page_path = "public/error.html"
    # response_code = "404"
  }


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = var.s3_bucket_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = var.country_blacklist
    }
  }

  viewer_certificate {
    # Enable for development mode. `cloudfront_default_certificate=true`
    # cloudfront_default_certificate = true
    cloudfront_default_certificate = var.mount_cloudfront_default_certificate
    # acm_certificate_arn = aws_acm_certificate.website_cert.arn
    acm_certificate_arn = var.aws_acm_certificate_arn
    ssl_support_method  = "sni-only"
    # minimum_protocol_version = "TLSv1.2_2019"
  }
}
