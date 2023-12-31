terraform {
  required_version = "1.6.6"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.1"
    }
    aws = {
      configuration_aliases = [
        aws,
        aws.global
      ]
      source  = "hashicorp/aws"
      version = "5.31.0"
    }
  }
}
