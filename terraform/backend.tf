terraform {
  backend "s3" {
    bucket         = "terraform-states-022327457572"
    dynamodb_table = "terraform-states-022327457572"
    key            = "ks-infrastructure/base.tfstate"
    region         = "eu-west-1"
    assume_role = {
      role_arn     = "arn:aws:iam::022327457572:role/ks-infrastructure"
      session_name = "terraform"
    }
  }
}
