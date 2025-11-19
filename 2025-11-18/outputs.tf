# output "sample" {
#   description = "demo for output"
#   value       = aws_vpc.main-eu-west-1.cidr_block
# }


# data "aws_availability_zones" "available1" {
#   state    = "available"
#   provider = aws.eu-west-1
# }

# data "aws_availability_zones" "available2" {
#   state    = "available"
#   provider = aws.us-east-2
# }

# output "working_azs1" {
#   value = data.aws_availability_zones.available1.names
# }

# output "working_azs2" {
#   value = data.aws_availability_zones.available2.names
# }

# output "website_url" {
#   value = "http://${aws_instance.public-linux-ec2.public_dns}"
# }

# output "ip_address" {
#   value = "http://${aws_instance.public-linux-ec2.public_ip}"
# }

# output "windows_password" {
#   value = rsadecrypt(aws_instance.public-win-bastion.password_data, file("id_rsa_windows_ec2"))
# }

# output "windows_bastion_ip_address" {
#   value = aws_instance.public-win-bastion.public_ip
# }

output "load_balancer_url" {
  value       = "http://${aws_lb.front-end.dns_name}"
  description = "The Load Balance DNS name"
}

output "ami_id" {
  value       = data.aws_ami.amazon_linux_2.image_id
  description = "The free tier eligible AMI"
}

