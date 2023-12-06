data "aws_route53_zone" "kitten_science" {
  name = local.domain_name
}
