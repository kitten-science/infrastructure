module "kitten_science_website" {
  source      = "./modules/kitten-science-website"
  bucket_name = "kitten-science-us0"
  domain_name = local.domain_name

  providers = {
    aws        = aws
    aws.global = aws.global
  }
}

resource "aws_route53_record" "github_validation" {
  name    = "_github-challenge-kitten-science-org"
  records = ["f6472ff274"]
  ttl     = 60
  type    = "TXT"
  zone_id = data.aws_route53_zone.kitten_science.id
}
