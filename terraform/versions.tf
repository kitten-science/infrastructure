terraform {
  required_version = "1.7.5"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.42.0"
    }
  }
}
