module "kitten_science_website" {
  source      = "./modules/kitten-science-website"
  bucket_name = "kitten-science-website"
  domain_name = "kitten-science.com"

  providers = {
    aws        = aws
    aws.global = aws.global
  }
}
