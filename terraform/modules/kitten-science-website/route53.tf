resource "aws_route53_record" "kitten_science_website" {
  for_each = toset([ "A", "AAAA" ])

  alias {
    evaluate_target_health = true
    name                   = aws_cloudfront_distribution.kitten_science_website.domain_name
    zone_id                = aws_cloudfront_distribution.kitten_science_website.hosted_zone_id
  }

  name    = var.domain_name
  type    = each.key
  zone_id = data.aws_route53_zone.kitten_science.zone_id
}