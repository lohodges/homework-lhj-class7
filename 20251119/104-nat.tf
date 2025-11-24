#--------------------------------------------------------------------
# NAT
#--------------------------------------------------------------------
resource "aws_nat_gateway" "us-east-2a" {
  allocation_id = aws_eip.nat-us-east-2.id
  subnet_id     = aws_subnet.public-us-east-2a.id

  tags = {
    Name = "nat-us-east-2"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw-us-east-2]
}

#--------------------------------------------------------------------
# EIP for NAT
#--------------------------------------------------------------------
resource "aws_eip" "nat-us-east-2" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-us-east-2"
  }
}