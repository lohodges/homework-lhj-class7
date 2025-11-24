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
  #cidr_ipv4   = "0.0.0.0/0"
  cidr_ipv4 = "73.67.73.63/32"
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