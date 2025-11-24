#--------------------------------------------------------------------
# IGW
#--------------------------------------------------------------------
resource "aws_internet_gateway" "gw-us-east-2" {
  vpc_id = aws_vpc.main-us-east-2.id

  tags = {
    Name = "gw-us-east-2"
  }

  depends_on = [aws_vpc.main-us-east-2]
}