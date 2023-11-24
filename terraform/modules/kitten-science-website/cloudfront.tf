# Certificate
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  key_algorithm     = "EC_prime256v1"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.global
}
resource "aws_route53_record" "this_validation" {
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
  zone_id         = data.aws_route53_zone.kitten_science.zone_id

  provider = aws.global
}
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.this_validation : record.fqdn]

  provider = aws.global
}

# Distribution
resource "aws_cloudfront_distribution" "this" {
  depends_on = [aws_acm_certificate_validation.this]

  aliases = [var.domain_name]

  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = aws_s3_bucket.this.bucket
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD"]
    response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id
    target_origin_id           = aws_s3_bucket.this.bucket

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.this.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  provider = aws.global
}

resource "aws_cloudfront_response_headers_policy" "this" {
  name = var.bucket_name

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = [
        "Accept",
        "Accept-Language",
        "Content-Language",
        "Content-Type",
        "Range"
      ]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD"]
    }

    access_control_allow_origins {
      items = [
        "https://kittensgame.com",
        "http://[::1]:8100",
        "http://127.0.0.1:8100",
        "http://localhost:8100"
      ]
    }

    origin_override = true
  }
}
