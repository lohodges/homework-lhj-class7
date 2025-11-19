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