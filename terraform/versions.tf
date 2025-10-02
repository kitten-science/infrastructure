terraform {
  required_version = ">= 1.8.2"

  required_providers {
    archive = {
      source  = "hashicorp/archive"
      version = "2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "6.15.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.6.0"
    }
  }
}
