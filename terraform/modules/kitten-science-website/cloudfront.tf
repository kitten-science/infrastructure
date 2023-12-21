# Certificate
resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  key_algorithm     = "EC_prime256v1"
  validation_method = "DNS"

  subject_alternative_names = [
    "schema.${var.domain_name}",
    "ks.rm-rf.link"
  ]

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.global
}
resource "aws_route53_record" "validation_kitten_science" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if endswith(dvo.domain_name, data.aws_route53_zone.kitten_science.name)
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.kitten_science.zone_id

  provider = aws.global
}
resource "aws_route53_record" "validation_rm_rf" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if endswith(dvo.domain_name, "rm-rf.link")
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.rm_rf.id

  provider = aws.global
}
resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
  validation_record_fqdns = concat(
    [for record in aws_route53_record.validation_kitten_science : record.fqdn],
    [for record in aws_route53_record.validation_rm_rf : record.fqdn]
  )

  provider = aws.global
}

data "aws_cloudfront_cache_policy" "uncached" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "cors" {
  name = "Managed-CORS-S3Origin"
}

# Distribution
resource "aws_cloudfront_distribution" "this" {
  depends_on = [aws_acm_certificate_validation.this]

  aliases = [
    var.domain_name,
    "ks.rm-rf.link"
  ]
  comment = "Kitten Science"

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
    cached_methods             = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id            = data.aws_cloudfront_cache_policy.uncached.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.cors.id
    response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id
    target_origin_id           = aws_s3_bucket.this.bucket

    lambda_function_association {
      event_type = "origin-request"
      lambda_arn = "${aws_lambda_function.redirect.arn}:${aws_lambda_function.redirect.version}"
    }

    compress = true

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }

  #logging_config {
  #  bucket = aws_s3_bucket.this.bucket_domain_name
  #  prefix = "cloudfront-logs/"
  #}

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
resource "aws_cloudfront_distribution" "schema" {
  depends_on = [aws_acm_certificate_validation.this]

  aliases = ["schema.${var.domain_name}"]
  comment = "Kitten Science Schemas"

  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = aws_s3_bucket_website_configuration.this.website_endpoint
    origin_id   = aws_s3_bucket.this.bucket
    origin_path = "/schemas"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods            = ["GET", "HEAD", "OPTIONS"]
    cached_methods             = ["GET", "HEAD", "OPTIONS"]
    response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id
    target_origin_id           = aws_s3_bucket.this.bucket

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
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
        "http://127.0.0.1:8100",
        "http://localhost:8100"
      ]
    }

    origin_override = true
  }
}
