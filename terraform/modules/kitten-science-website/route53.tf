resource "aws_route53_record" "this" {
  for_each = toset(["A", "AAAA"])

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
  }

  name    = local.fqdn
  type    = each.key
  zone_id = data.aws_route53_zone.domain.zone_id
}
