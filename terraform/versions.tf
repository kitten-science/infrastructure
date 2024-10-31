terraform {
  required_version = ">= 1.8.2"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.6.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.74.0"
    }
  }
}
