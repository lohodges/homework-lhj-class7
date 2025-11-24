#--------------------------------------------------------------------
# Subnets us-east-2 PUBLIC
#--------------------------------------------------------------------
resource "aws_subnet" "public-us-east-2a" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.1.0/24"
  availability_zone = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2a"
  }
}

resource "aws_subnet" "public-us-east-2b" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.2.0/24"
  availability_zone = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2b"
  }
}

resource "aws_subnet" "public-us-east-2c" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.3.0/24"
  availability_zone = "us-east-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2c"
  }
}

#--------------------------------------------------------------------
# Subnets us-east-2 PRIVATE
#--------------------------------------------------------------------
resource "aws_subnet" "private-us-east-2a" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.11.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-2a"
  }
}

resource "aws_subnet" "private-us-east-2b" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.12.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-2b"
  }
}

resource "aws_subnet" "private-us-east-2c" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.13.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-us-east-2c"
  }
}

resource "aws_subnet" "db-private-us-east-2a" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.101.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name    = "private-us-east-2a"
    Service = "Aurora/Postgresql"
  }
}