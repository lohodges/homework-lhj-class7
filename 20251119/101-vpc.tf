#--------------------------------------------------------------------
# VPC us-east-2
#--------------------------------------------------------------------
resource "aws_vpc" "main-us-east-2" {
  cidr_block           = "10.53.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = false
  enable_dns_support   = true

  tags = {
    Name = "us-east-2-vpc"
  }
}