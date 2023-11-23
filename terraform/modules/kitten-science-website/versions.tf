terraform {
  required_version = ">= 1.6.4"

  required_providers {
    aws = {
      configuration_aliases = [
        aws,
        aws.global
      ]
      source  = "hashicorp/aws"
      version = ">= 5.26.0"
    }
  }
}
