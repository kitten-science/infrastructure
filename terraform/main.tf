locals {
  domain_name = "kitten-science.com"
}
data "aws_route53_zone" "kitten_science" {
  name = local.domain_name
}

resource "aws_s3_bucket" "kitten_science_website" {
  bucket = "kitten-science-website"
}
resource "aws_s3_bucket_ownership_controls" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
resource "aws_s3_bucket_public_access_block" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
resource "aws_s3_bucket_acl" "kitten_science_website" {
  depends_on = [
    aws_s3_bucket_ownership_controls.kitten_science_website,
    aws_s3_bucket_public_access_block.kitten_science_website,
  ]

  bucket = aws_s3_bucket.kitten_science_website.id
  acl    = "public-read"
}
resource "aws_s3_bucket_website_configuration" "kitten_science_website" {
  bucket = aws_s3_bucket.kitten_science_website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_acm_certificate" "kitten_science_website" {
  domain_name       = local.domain_name
  key_algorithm     = "EC_prime256v1"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  provider = aws.global
}
resource "aws_route53_record" "kitten_science_website_validation" {
  for_each = {
    for dvo in aws_acm_certificate.kitten_science_website.domain_validation_options : dvo.domain_name => {
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
resource "aws_acm_certificate_validation" "kitten_science_website" {
  certificate_arn         = aws_acm_certificate.kitten_science_website.arn
  validation_record_fqdns = [for record in aws_route53_record.kitten_science_website_validation : record.fqdn]

  provider = aws.global
}

resource "aws_cloudfront_distribution" "kitten_science_website" {
  depends_on = [aws_acm_certificate_validation.kitten_science_website]

  aliases = [local.domain_name]

  enabled         = true
  is_ipv6_enabled = true

  origin {
    domain_name = aws_s3_bucket_website_configuration.kitten_science_website.website_endpoint
    origin_id   = aws_s3_bucket.kitten_science_website.bucket
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.kitten_science_website.bucket

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
    acm_certificate_arn      = aws_acm_certificate.kitten_science_website.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }

  provider = aws.global
}

resource "aws_route53_record" "kitten_science_website" {
  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.kitten_science_website.domain_name
    zone_id                = aws_cloudfront_distribution.kitten_science_website.hosted_zone_id
  }

  name    = local.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.kitten_science.zone_id
}
