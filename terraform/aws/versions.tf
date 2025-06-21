terraform {
  required_version = ">= 1.8.2"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = ">=2.7.1"
    }
    aws = {
      source                = "hashicorp/aws"
      version               = ">=5.98.0"
      configuration_aliases = [aws.global]
    }
  }
}
