terraform {
  required_version = "1.8.1"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
    aws = {
      configuration_aliases = [
        aws,
        aws.global
      ]
      source  = "hashicorp/aws"
      version = "5.47.0"
    }
  }
}
