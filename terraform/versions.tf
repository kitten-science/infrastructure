terraform {
  required_version = ">= 1.8.2"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.32.1"
    }
  }
}
