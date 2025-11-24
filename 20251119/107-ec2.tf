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
# Compute - Windows Server Bastion
#--------------------------------------------------------------------
# resource "aws_instance" "public-win-bastion" {
#   provider                    = aws.eu-west-1
#   ami                         = "ami-04b1756cd8ff18ec6"
#   instance_type               = "t3.large"
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public-eu-west-1c.id
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
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# resource "aws_instance" "private-linux-ec2" {
#   ami = data.aws_ami.amazon_linux_2.image_id
#   instance_type               = "t2.micro"
#   associate_public_ip_address = false
#   subnet_id                   = aws_subnet.private-eu-west-1a.id
#   vpc_security_group_ids      = [aws_security_group.private-linux-ec2.id, aws_security_group.allow_all_egress.id]
#   key_name                    = aws_key_pair.linux.key_name
#   user_data                   = file("user_data_ec2_linux.sh")

#   tags = {
#     Name = "private-linux-ec2"
#   }
# }

# resource "aws_instance" "public-linux-ec2" {
#   ami                         = data.aws_ami.amazon_linux_2.image_id
#   instance_type               = "t2.micro"
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.public-us-east-2a.id
#   vpc_security_group_ids = [
#     aws_security_group.ssh.id,
#     aws_security_group.shared_egress.id,
#     aws_security_group.shared_public_access.id
#   ]
#   key_name = aws_key_pair.linux.key_name
#   # user_data = file("user_data_ec2_linux.sh")

#   tags = {
#     Name = "public-linux-ec2-bastion"
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