#--------------------------------------------------------------------
# ROUTE TABLES - PUBLIC
#--------------------------------------------------------------------
resource "aws_route_table" "public-us-east-2" {
  vpc_id = aws_vpc.main-us-east-2.id

  depends_on = [aws_internet_gateway.gw-us-east-2]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw-us-east-2.id
  }

  tags = {
    Name = "public-rtb-us-east-2"
  }
}

#--------------------------------------------------------------------
# ROUTE TABLES - PRIVATE
#--------------------------------------------------------------------
resource "aws_route_table" "private-us-east-2a" {
  vpc_id = aws_vpc.main-us-east-2.id

  depends_on = [aws_nat_gateway.us-east-2a]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-2a.id
  }

  tags = {
    Name = "private1-rtb-us-east-2"
  }
}

resource "aws_route_table" "private-us-east-2b" {
  vpc_id = aws_vpc.main-us-east-2.id

  depends_on = [aws_nat_gateway.us-east-2a]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-2a.id
  }

  tags = {
    Name = "private2-rtb-us-east-2"
  }
}

resource "aws_route_table" "private-us-east-2c" {
  vpc_id = aws_vpc.main-us-east-2.id

  depends_on = [aws_nat_gateway.us-east-2a]

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.us-east-2a.id
  }

  tags = {
    Name = "private3-rtb-us-east-2"
  }
}

#--------------------------------------------------------------------
# ROUTE TABLE ASSOCIATIONS us-east-2 PUBLIC
#--------------------------------------------------------------------
resource "aws_route_table_association" "public-us-east-2a" {
  subnet_id      = aws_subnet.public-us-east-2a.id
  route_table_id = aws_route_table.public-us-east-2.id
}

resource "aws_route_table_association" "public-us-east-2b" {
  subnet_id      = aws_subnet.public-us-east-2b.id
  route_table_id = aws_route_table.public-us-east-2.id
}

resource "aws_route_table_association" "public-us-east-2c" {
  subnet_id      = aws_subnet.public-us-east-2c.id
  route_table_id = aws_route_table.public-us-east-2.id
}


#--------------------------------------------------------------------
# ROUTE TABLE ASSOCIATIONS us-east-2 PRIVATE
#--------------------------------------------------------------------
resource "aws_route_table_association" "private-us-east-2a" {
  subnet_id      = aws_subnet.private-us-east-2a.id
  route_table_id = aws_route_table.private-us-east-2a.id
}

resource "aws_route_table_association" "private-us-east-2b" {
  subnet_id      = aws_subnet.private-us-east-2b.id
  route_table_id = aws_route_table.private-us-east-2b.id
}

resource "aws_route_table_association" "private-us-east-2c" {
  subnet_id      = aws_subnet.private-us-east-2c.id
  route_table_id = aws_route_table.private-us-east-2c.id
}