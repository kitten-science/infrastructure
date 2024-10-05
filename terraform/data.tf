data "aws_route53_zone" "kitten_science" {
  name = local.domain_name
}

data "aws_cloudfront_log_delivery_canonical_user_id" "current" {}

data "aws_canonical_user_id" "current" {}
