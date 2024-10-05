data "aws_route53_zone" "domain" {
  name = var.domain_name
}

data "aws_cloudfront_cache_policy" "uncached" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "cors" {
  name = "Managed-CORS-S3Origin"
}
