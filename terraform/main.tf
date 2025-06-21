module "scm" {
  source = "./github"

  providers = {
    github = github
  }
}

module "web" {
  source = "./aws"

  bucket_name = local.bucket_name
  domain_name = local.domain_name

  providers = {
    aws        = aws
    aws.global = aws.global
  }
}
