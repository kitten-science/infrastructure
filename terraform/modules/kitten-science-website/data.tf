data "aws_route53_zone" "kitten_science" {
  name = var.domain_name
}
data "aws_route53_zone" "rm_rf" {
  name = "rm-rf.link"
}
