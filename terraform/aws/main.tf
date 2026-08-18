module "kitten_science_website_beta11" {
  source = "./modules/kitten-science-website"

  comment         = "Kitten Science"
  domain_name     = var.domain_name
  log_bucket_arn  = aws_s3_bucket.logs.arn
  log_bucket_name = aws_s3_bucket.logs.bucket_domain_name

  origin_domain_name         = aws_s3_bucket.this.bucket_regional_domain_name
  origin_id                  = aws_s3_bucket.this.bucket
  response_headers_policy_id = aws_cloudfront_response_headers_policy.this.id

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
# We validate with CNAME instead of TXT, because we don't want to litter
# the TXT for the apex.
resource "aws_route53_record" "google_validation" {
  name    = "4cxdfxct3lp3"
  records = ["gv-qjx2j6abkk3aej.dv.googlehosted.com"]
  ttl     = 60
  type    = "CNAME"
  zone_id = data.aws_route53_zone.kitten_science.id
}
