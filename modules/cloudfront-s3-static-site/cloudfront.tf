resource "aws_cloudfront_origin_access_control" "static_site" {
  name                              = "${var_s3_bucket.site_bucket.id}-s3-cloudfront-oac"
  description                       = "Access Cloudfront to operate on the ${aws_s3_bucket.site_bucket.id} bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

locals {
  s3_origin_id = "s3-${var.s3_bucket_name}-origin"
}

resource "aws_cloudfront_distribution" "static_site" {
  origin {
    domain_name              = aws_s3_bucket.site_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.static_site.id
    origin_id                = local.s3_origin_id
#   origin_path              = "/${var.s3_origin_path}"
    origin_path              = var.s3_origin_path
    }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Static site for ${var.subdomain}.${var.hosted_zone_domain_name}"
  default_root_object = "index.html"

  # logging_config {
  #   include_cookies = false
  #   bucket          = "mylogs.s3.amazonaws.com"
  #   prefix          = "myprefix"
  # }

  aliases = [local.domain_name, "www.${local.domain_name}"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  custom_error_response {
    error_code      = 403
    response_code   = 200
    response_page_path = "/error-403.html"
  }
  custom_error_response {
    error_code      = 404
    response_code   = 200
    response_page_path = "/error-404.html"
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern     = "/content/immutable/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "blacklist"
      locations        = ["CN", "RU", "KP", "IN", "PK"]
    }
  }

  tags = merge(
      {
        "Name" = "${var.subdomain}.${var.hosted_zone_domain_name}"
      },
      var.extra_tags)

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.site_cert.arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
