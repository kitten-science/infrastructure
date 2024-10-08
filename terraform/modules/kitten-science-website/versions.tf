terraform {
  required_version = ">= 1.8.2"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = ">= 2.4.2"
    }
    aws = {
      configuration_aliases = [
        aws,
        aws.global
      ]
      source  = "hashicorp/aws"
      version = ">= 5.60.0"
    }
  }
}
