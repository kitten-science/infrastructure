terraform {
  required_version = "1.6.6"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.33.0"
    }
  }
}
