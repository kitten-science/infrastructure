data "aws_route53_zone" "kitten_science" {
  name = var.domain_name
}
