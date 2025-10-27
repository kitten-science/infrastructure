provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = local.tags
  }
}

provider "aws" {
  alias  = "global"
  region = "us-east-1"

  default_tags {
    tags = local.tags
  }
}
