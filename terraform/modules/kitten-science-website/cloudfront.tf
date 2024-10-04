# Certificate
resource "aws_acm_certificate" "this" {
  domain_name       = local.fqdn
  key_algorithm     = "EC_prime256v1"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.global
}
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    } if endswith(dvo.domain_name, data.aws_route53_zone.domain.name)
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.domain.zone_id

  provider = aws.global
}
resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]

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
    local.fqdn
  ]
  comment = var.comment

  enabled         = true
  http_version    = "http2and3"
  is_ipv6_enabled = true
  web_acl_id      = "arn:aws:wafv2:us-east-1:022327457572:global/webacl/CreatedByCloudFront-04e49c94-b220-44e4-9240-3da00e9602aa/d0878d05-aca4-4611-820d-26bbf1fd3ede"

  retain_on_delete    = true
  wait_for_deployment = false

  origin {
    domain_name = var.origin_domain_name
    origin_id   = var.origin_id
    origin_path = var.origin_path
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
    response_headers_policy_id = var.response_headers_policy_id
    target_origin_id           = var.origin_id

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
