#--------------------------------------------------------------------
# VPC us-east-2
#--------------------------------------------------------------------
resource "aws_vpc" "main-us-east-2" {
  cidr_block           = "10.53.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "us-east-2-vpc"
  }
}

#--------------------------------------------------------------------
# Subnets us-east-2 PUBLIC
#--------------------------------------------------------------------
resource "aws_subnet" "public-us-east-2a" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.1.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2a"
  }
}

resource "aws_subnet" "public-us-east-2b" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2b"
  }
}

resource "aws_subnet" "public-us-east-2c" {
  vpc_id                  = aws_vpc.main-us-east-2.id
  cidr_block              = "10.53.3.0/24"
  availability_zone       = "us-east-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-east-2c"
  }
}

#--------------------------------------------------------------------
# Subnets us-east-2 PRIVATE
#--------------------------------------------------------------------
resource "aws_subnet" "private-us-east-2a" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.11.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "private-us-east-2a"
  }
}

resource "aws_subnet" "private-us-east-2b" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.12.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "private-us-east-2b"
  }
}

resource "aws_subnet" "private-us-east-2c" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.13.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "private-us-east-2c"
  }
}

resource "aws_subnet" "db-private-us-east-2a" {
  vpc_id            = aws_vpc.main-us-east-2.id
  cidr_block        = "10.53.101.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name    = "private-us-east-2a"
    Service = "Aurora/Postgresql"
  }
}

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
# EIP for IGW and NAT
#--------------------------------------------------------------------
resource "aws_eip" "igw-gw-us-east-2" {
  domain = "vpc"

  depends_on = [aws_internet_gateway.gw-us-east-2]

  tags = {
    Name = "eip-gw-us-east-2"
  }
}

resource "aws_eip" "nat-us-east-2" {
  domain = "vpc"

  tags = {
    Name = "eip-nat-us-east-2"
  }
}

#--------------------------------------------------------------------
# Security Groups
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
# resource "aws_security_group" "example" {
#   name        = "example"
#   description = "example"
#   vpc_id      = aws_vpc.main.id
#   tags = {
#     Name = "example"
#   }
# }
#
# resource "aws_vpc_security_group_egress_rule" "example" {
#   security_group_id = aws_security_group.example.id
#
#   cidr_ipv4   = "10.0.0.0/8"
#   from_port   = 80
#   ip_protocol = "tcp"
#   to_port     = 80
# }
#
#
#
# resource "aws_vpc_security_group_ingress_rule" "example" {
#   security_group_id = aws_security_group.example.id

#   cidr_ipv4   = "10.0.0.0/8"
#   from_port   = 80
#   ip_protocol = "tcp"
#   to_port     = 80
# }
#--------------------------------------------------------------------
resource "aws_security_group" "shared_egress" {

  name        = "all_egress-"
  description = "Allow all egress"
  vpc_id      = aws_vpc.main-us-east-2.id

  tags = {
    Name = "shared_all_egress"
  }
}

resource "aws_vpc_security_group_egress_rule" "shared_egress_all" {

  security_group_id = aws_security_group.shared_egress.id
  description       = "Allow all egress. Attach to egress rule for any SG that needs it."

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "shared_public_access" {

  name_prefix = "http_https-"
  description = "Allow HTTP, HTTPS"
  vpc_id      = aws_vpc.main-us-east-2.id

  tags = {
    Name = "shared_public_access"
  }
}

resource "aws_vpc_security_group_ingress_rule" "shared_public_access_http" {

  security_group_id = aws_security_group.shared_public_access.id
  description       = "Allow HTTP"

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "shared_public_access_https" {

  security_group_id = aws_security_group.shared_public_access.id
  description       = "Allow HTTPS"

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  to_port     = 443
}

resource "aws_security_group" "ssh" {

  name_prefix = "ssh-"
  description = "Allow SSH"
  vpc_id      = aws_vpc.main-us-east-2.id

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {

  security_group_id = aws_security_group.ssh.id
  description       = "Allow SSH"

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  #cidr_ipv4 = "xx.xx.xx.xx/32"
  from_port = 22
  to_port   = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_private" {

  security_group_id = aws_security_group.ssh.id
  description       = "Allow SSH private"

  ip_protocol = "tcp"
  cidr_ipv4   = aws_vpc.main-us-east-2.cidr_block
  from_port   = 22
  to_port     = 22
}

resource "aws_security_group" "lb_sg" {
  name_prefix = "lb-"
  description = "Allow HTTP for Load Balancer"
  vpc_id      = aws_vpc.main-us-east-2.id

  tags = {
    Name = "load_balancer"
  }
}

resource "aws_vpc_security_group_ingress_rule" "lb_sg" {
  security_group_id = aws_security_group.lb_sg.id
  description       = "Allow Load Balancer inbound traffic from all"

  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "lb_sg" {
  security_group_id = aws_security_group.lb_sg.id
  # referenced_security_group_id = aws_security_group.shared_public_access.id
  # cidr_ipv4   = "10.53.0.0/16"
  # ip_protocol = "tcp"
  # from_port   = 80
  # to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "lb-tg-ec2" {
  name_prefix = "lb-tg-ec2-"
  description = "attach to EC2"
  vpc_id      = aws_vpc.main-us-east-2.id
}

resource "aws_vpc_security_group_ingress_rule" "lb-tg-ec2" {
  referenced_security_group_id = aws_security_group.lb_sg.id
  security_group_id            = aws_security_group.lb-tg-ec2.id
  description                  = "Allow Load Balancer inbound traffic from all"

  ip_protocol = "tcp"
  # cidr_ipv4   = "0.0.0.0/0"
  from_port = 80
  to_port   = 80
}

resource "aws_vpc_security_group_egress_rule" "lb-tg-ec2_out" {
  security_group_id = aws_security_group.lb-tg-ec2.id
  # referenced_security_group_id = aws_security_group.shared_public_access.id
  # cidr_ipv4   = "10.53.0.0/16"
  # ip_protocol = "tcp"
  # from_port   = 80
  # to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}




#--------------------------------------------------------------------
# Compute - Windows Server Bastion
#--------------------------------------------------------------------
# resource "aws_instance" "public-win-bastion" {
#   
#   ami                         = "ami-04b1756cd8ff18ec6"
#   instance_type               = "t3.large"
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public-us-east-2c.id
#   vpc_security_group_ids      = [aws_security_group.allow_rdp.id, aws_security_group.allow_all_egress.id]
#   key_name                    = aws_key_pair.windows.key_name
#   get_password_data           = true

#   tags = {
#     Name = "public-windows-bastion"
#   }
# }

#--------------------------------------------------------------------
# Compute - Linux EC2
#--------------------------------------------------------------------
# resource "aws_instance" "public-linux-ec2" {

#   ami                         = "ami-0049e4b5ba14b6d36"
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public-us-east-2a.id
#   vpc_security_group_ids      = [aws_security_group.shared_public_access.id, aws_security_group.shared_egress.id, aws_security_group.ssh.id]
#   key_name                    = aws_key_pair.linux.key_name
#   user_data                   = file("user_data_ec2_linux.sh")

#   tags = {
#     Name = "public-linux-ec2"
#   }
# }

# resource "aws_instance" "private-linux-ec2" {

#   ami                    = "ami-0049e4b5ba14b6d36"
#   instance_type          = "t2.micro"
#   subnet_id              = aws_subnet.private-us-east-2b.id
#   vpc_security_group_ids = [aws_security_group.shared_public_access.id, aws_security_group.shared_egress.id, aws_security_group.ssh.id]
#   key_name               = aws_key_pair.linux.key_name
#   user_data              = file("user_data_ec2_linux-private.sh")

#   tags = {
#     Name = "private-linux-ec2"
#   }
# }

#--------------------------------------------------------------------
# Compute - Key Pairs
#
# Windows:  https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_keymanagement
# Linux/Mac: https://www.ssh.com/academy/ssh/keygen
# Linux/Mac: https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
#--------------------------------------------------------------------
resource "aws_key_pair" "linux" {
  public_key      = file("id_ed25519_aws_ec2.pub")
  key_name_prefix = "lonix-"
}

# resource "aws_key_pair" "windows" {
#   public_key = file("id_rsa_windows_ec2.pub")
# }
