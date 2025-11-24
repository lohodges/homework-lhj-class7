terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.18.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"

  default_tags {
    tags = {
      ManagedBy    = "Terraform"
      LeadEngineer = "Lonnie Hodges"
      Company      = "LHJ"
    }
  }
}