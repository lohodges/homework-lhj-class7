resource "aws_lb" "front-end" {
  name               = "lb-front-end"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets = [
    aws_subnet.public-us-east-2a.id,
    aws_subnet.public-us-east-2b.id,
    aws_subnet.public-us-east-2c.id
  ]
  ip_address_type = "ipv4"

}

resource "aws_lb_listener" "front-end" {
  load_balancer_arn = aws_lb.front-end.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front-end.arn
  }
}


resource "aws_lb_target_group" "front-end" {
  name        = "tg-front-end"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main-us-east-2.id

  health_check {
    interval            = 10
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_autoscaling_group" "front-end" {
  name = "asg-front-end"
  # availability_zones        = ["us-east-2a"] # used default VPC, conflicts with vpc_zone_identifier
  min_size                  = 3
  max_size                  = 6
  desired_capacity          = 3
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  vpc_zone_identifier = [
    aws_subnet.private-us-east-2a.id,
    aws_subnet.private-us-east-2b.id,
    aws_subnet.private-us-east-2c.id
  ]
  target_group_arns = [aws_lb_target_group.front-end.arn]

  launch_template {
    id      = aws_launch_template.ec2-linux-private.id
    version = aws_launch_template.ec2-linux-private.latest_version
  }
}

# Auto Scaling Policy
resource "aws_autoscaling_policy" "frontend_scaling_policy" {
  name                   = "frontend-cpu-target"
  autoscaling_group_name = aws_autoscaling_group.front-end.name

  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 120

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    #target_value = 75.0
    target_value = 50.0
  }
}

# Enabling instance scale-in protection
resource "aws_autoscaling_attachment" "app1_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.front-end.name
  lb_target_group_arn    = aws_lb_target_group.front-end.arn
}

#-----------------------------------------------------------------------------------------
# Launch Template
#-----------------------------------------------------------------------------------------
resource "aws_launch_template" "ec2-linux-private" {
  description             = "lt-for-asg"
  disable_api_stop        = true
  disable_api_termination = true
  image_id                = data.aws_ami.amazon_linux_2.image_id
  instance_type           = "t2.micro"
  key_name                = aws_key_pair.linux.key_name
  name_prefix             = "lt-for-asg-"
  region                  = "us-east-2"
  tags                    = {}
  tags_all                = {}
  # user_data               = "IyEvYmluL2Jhc2gKIyBVc2UgdGhpcyBmb3IgeW91ciB1c2VyIGRhdGEgKHNjcmlwdCBmcm9tIHRvcCB0byBib3R0b20pCiMgaW5zdGFsbCBodHRwZCAoTGludXggMiB2ZXJzaW9uKQp5dW0gdXBkYXRlIC15Cnl1bSBpbnN0YWxsIC15IGh0dHBkCnN5c3RlbWN0bCBzdGFydCBodHRwZApzeXN0ZW1jdGwgZW5hYmxlIGh0dHBkCgojIEdldCB0aGUgSU1EU3YyIHRva2VuClRPS0VOPSQoY3VybCAtWCBQVVQgImh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L2FwaS90b2tlbiIgLUggIlgtYXdzLWVjMi1tZXRhZGF0YS10b2tlbi10dGwtc2Vjb25kczogMjE2MDAiKQoKIyBCYWNrZ3JvdW5kIHRoZSBjdXJsIHJlcXVlc3RzCmN1cmwgLUggIlgtYXdzLWVjMi1tZXRhZGF0YS10b2tlbjogJFRPS0VOIiAtcyBodHRwOi8vMTY5LjI1NC4xNjkuMjU0L2xhdGVzdC9tZXRhLWRhdGEvbG9jYWwtaXB2NCAmPiAvdG1wL2xvY2FsX2lwdjQgJgpjdXJsIC1IICJYLWF3cy1lYzItbWV0YWRhdGEtdG9rZW46ICRUT0tFTiIgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL3BsYWNlbWVudC9hdmFpbGFiaWxpdHktem9uZSAmPiAvdG1wL2F6ICYKY3VybCAtSCAiWC1hd3MtZWMyLW1ldGFkYXRhLXRva2VuOiAkVE9LRU4iIC1zIGh0dHA6Ly8xNjkuMjU0LjE2OS4yNTQvbGF0ZXN0L21ldGEtZGF0YS9uZXR3b3JrL2ludGVyZmFjZXMvbWFjcy8gJj4gL3RtcC9tYWNpZCAmCndhaXQKCm1hY2lkPSQoY2F0IC90bXAvbWFjaWQpCmxvY2FsX2lwdjQ9JChjYXQgL3RtcC9sb2NhbF9pcHY0KQphej0kKGNhdCAvdG1wL2F6KQp2cGM9JChjdXJsIC1IICJYLWF3cy1lYzItbWV0YWRhdGEtdG9rZW46ICRUT0tFTiIgLXMgaHR0cDovLzE2OS4yNTQuMTY5LjI1NC9sYXRlc3QvbWV0YS1kYXRhL25ldHdvcmsvaW50ZXJmYWNlcy9tYWNzLyR7bWFjaWR9L3ZwYy1pZCkKCiMgR2V0IGhvc3RuYW1lCmhvc3RuYW1lX3ZhbHVlPSQoaG9zdG5hbWUgLWYpCgpjYXQgPiAvdmFyL3d3dy9odG1sL2luZGV4Lmh0bWwgPDwgRU9GCjwhRE9DVFlQRSBodG1sPgo8aHRtbCBsYW5nPSJlbiI+CjxoZWFkPgogICAgPG1ldGEgY2hhcnNldD0iVVRGLTgiPgogICAgPG1ldGEgbmFtZT0idmlld3BvcnQiIGNvbnRlbnQ9IndpZHRoPWRldmljZS13aWR0aCwgaW5pdGlhbC1zY2FsZT0xLjAiPgogICAgPHRpdGxlPkkgbG92ZSBtb25leTwvdGl0bGU+CiAgICA8c3R5bGU+CiAgICAgICAgKiB7CiAgICAgICAgICAgIG1hcmdpbjogMDsKICAgICAgICAgICAgcGFkZGluZzogMDsKICAgICAgICAgICAgYm94LXNpemluZzogYm9yZGVyLWJveDsKICAgICAgICB9CiAgICAgICAgCiAgICAgICAgYm9keSB7CiAgICAgICAgICAgIGZvbnQtZmFtaWx5OiAtYXBwbGUtc3lzdGVtLCBCbGlua01hY1N5c3RlbUZvbnQsICdTZWdvZSBVSScsIFJvYm90bywgT3h5Z2VuLCBVYnVudHUsIENhbnRhcmVsbCwgc2Fucy1zZXJpZjsKICAgICAgICAgICAgYmFja2dyb3VuZDogIzFhMWExYTsKICAgICAgICAgICAgbWluLWhlaWdodDogMTAwdmg7CiAgICAgICAgICAgIHBhZGRpbmc6IDQwcHggMjBweDsKICAgICAgICB9CiAgICAgICAgCiAgICAgICAgLmNvbnRhaW5lciB7CiAgICAgICAgICAgIG1heC13aWR0aDogMTAwMHB4OwogICAgICAgICAgICBtYXJnaW46IDAgYXV0bzsKICAgICAgICAgICAgYmFja2dyb3VuZDogI2ZmZmZmZjsKICAgICAgICAgICAgYm9yZGVyLXJhZGl1czogMTZweDsKICAgICAgICAgICAgcGFkZGluZzogNDBweDsKICAgICAgICAgICAgYm94LXNoYWRvdzogMCAyMHB4IDYwcHggcmdiYSgwLDAsMCwwLjUpOwogICAgICAgIH0KICAgICAgICAKICAgICAgICBoMSB7CiAgICAgICAgICAgIGNvbG9yOiAjMDAwMDAwOwogICAgICAgICAgICBmb250LXNpemU6IDNyZW07CiAgICAgICAgICAgIG1hcmdpbi1ib3R0b206IDEwcHg7CiAgICAgICAgICAgIHRleHQtYWxpZ246IGNlbnRlcjsKICAgICAgICAgICAgZm9udC13ZWlnaHQ6IDcwMDsKICAgICAgICB9CiAgICAgICAgCiAgICAgICAgaDIgewogICAgICAgICAgICBjb2xvcjogIzY2NjY2NjsKICAgICAgICAgICAgZm9udC1zaXplOiAxLjVyZW07CiAgICAgICAgICAgIG1hcmdpbi1ib3R0b206IDQwcHg7CiAgICAgICAgICAgIHRleHQtYWxpZ246IGNlbnRlcjsKICAgICAgICAgICAgZm9udC13ZWlnaHQ6IDUwMDsKICAgICAgICB9CiAgICAgICAgCiAgICAgICAgLmhlcm8taW1hZ2UgewogICAgICAgICAgICB3aWR0aDogMTAwJTsKICAgICAgICAgICAgbWF4LXdpZHRoOiA4MDBweDsKICAgICAgICAgICAgbWFyZ2luOiAwIGF1dG8gNDBweDsKICAgICAgICAgICAgZGlzcGxheTogYmxvY2s7CiAgICAgICAgICAgIGJvcmRlci1yYWRpdXM6IDEycHg7CiAgICAgICAgICAgIGJvcmRlcjogM3B4IHNvbGlkICMwMDAwMDA7CiAgICAgICAgICAgIGJveC1zaGFkb3c6IDAgOHB4IDI0cHggcmdiYSgwLDAsMCwwLjMpOwogICAgICAgIH0KICAgICAgICAKICAgICAgICAuZGV0YWlscyB7CiAgICAgICAgICAgIGJhY2tncm91bmQ6ICNmNWY1ZjU7CiAgICAgICAgICAgIGJvcmRlcjogMnB4IHNvbGlkICMzMzMzMzM7CiAgICAgICAgICAgIGJvcmRlci1yYWRpdXM6IDEycHg7CiAgICAgICAgICAgIHBhZGRpbmc6IDMwcHg7CiAgICAgICAgICAgIG1hcmdpbi10b3A6IDQwcHg7CiAgICAgICAgfQogICAgICAgIAogICAgICAgIC5kZXRhaWxzIGgzIHsKICAgICAgICAgICAgY29sb3I6ICMwMDAwMDA7CiAgICAgICAgICAgIGZvbnQtc2l6ZTogMS41cmVtOwogICAgICAgICAgICBtYXJnaW4tYm90dG9tOiAyMHB4OwogICAgICAgICAgICBib3JkZXItYm90dG9tOiAzcHggc29saWQgIzMzMzMzMzsKICAgICAgICAgICAgcGFkZGluZy1ib3R0b206IDEwcHg7CiAgICAgICAgICAgIGZvbnQtd2VpZ2h0OiA2MDA7CiAgICAgICAgfQogICAgICAgIAogICAgICAgIC5kZXRhaWwtaXRlbSB7CiAgICAgICAgICAgIGRpc3BsYXk6IGZsZXg7CiAgICAgICAgICAgIHBhZGRpbmc6IDE1cHggMDsKICAgICAgICAgICAgYm9yZGVyLWJvdHRvbTogMXB4IHNvbGlkICNjY2NjY2M7CiAgICAgICAgfQogICAgICAgIAogICAgICAgIC5kZXRhaWwtaXRlbTpsYXN0LWNoaWxkIHsKICAgICAgICAgICAgYm9yZGVyLWJvdHRvbTogbm9uZTsKICAgICAgICB9CiAgICAgICAgCiAgICAgICAgLmRldGFpbC1sYWJlbCB7CiAgICAgICAgICAgIGZvbnQtd2VpZ2h0OiA2MDA7CiAgICAgICAgICAgIGNvbG9yOiAjMDAwMDAwOwogICAgICAgICAgICBtaW4td2lkdGg6IDIwMHB4OwogICAgICAgICAgICBmb250LXNpemU6IDFyZW07CiAgICAgICAgfQogICAgICAgIAogICAgICAgIC5kZXRhaWwtdmFsdWUgewogICAgICAgICAgICBjb2xvcjogIzFhMWExYTsKICAgICAgICAgICAgZm9udC1mYW1pbHk6ICdDb3VyaWVyIE5ldycsIG1vbm9zcGFjZTsKICAgICAgICAgICAgYmFja2dyb3VuZDogd2hpdGU7CiAgICAgICAgICAgIHBhZGRpbmc6IDZweCAxNHB4OwogICAgICAgICAgICBib3JkZXItcmFkaXVzOiA2cHg7CiAgICAgICAgICAgIGJvcmRlcjogMnB4IHNvbGlkICMzMzMzMzM7CiAgICAgICAgICAgIGZvbnQtc2l6ZTogMC45NXJlbTsKICAgICAgICB9CiAgICA8L3N0eWxlPgo8L2hlYWQ+Cjxib2R5PgogICAgPGRpdiBjbGFzcz0iY29udGFpbmVyIj4KICAgICAgICA8aDE+SSBsb3ZlIE1vbmV5IC0gUFJJVkFURTwvaDE+CiAgICAgICAgPGgyPkFXUyBJbnN0YW5jZSBNZXRhZGF0YTwvaDI+CiAgICAgICAgPGltZyBzcmM9Imh0dHBzOi8vaS5lYmF5aW1nLmNvbS9pbWFnZXMvZy9USGNBQU9Td3NGSmVGNmhlL3MtbDE2MDAud2VicCIgYWx0PSJMaXp6byIgY2xhc3M9Imhlcm8taW1hZ2UiPgogICAgICAgIAogICAgICAgIDxkaXYgY2xhc3M9ImRldGFpbHMiPgogICAgICAgICAgICA8aDM+SW5zdGFuY2UgSW5mb3JtYXRpb248L2gzPgogICAgICAgICAgICA8ZGl2IGNsYXNzPSJkZXRhaWwtaXRlbSI+CiAgICAgICAgICAgICAgICA8c3BhbiBjbGFzcz0iZGV0YWlsLWxhYmVsIj5JbnN0YW5jZSBOYW1lOjwvc3Bhbj4KICAgICAgICAgICAgICAgIDxzcGFuIGNsYXNzPSJkZXRhaWwtdmFsdWUiPiR7aG9zdG5hbWVfdmFsdWV9PC9zcGFuPgogICAgICAgICAgICA8L2Rpdj4KICAgICAgICAgICAgPGRpdiBjbGFzcz0iZGV0YWlsLWl0ZW0iPgogICAgICAgICAgICAgICAgPHNwYW4gY2xhc3M9ImRldGFpbC1sYWJlbCI+UHJpdmF0ZSBJUCBBZGRyZXNzOjwvc3Bhbj4KICAgICAgICAgICAgICAgIDxzcGFuIGNsYXNzPSJkZXRhaWwtdmFsdWUiPiR7bG9jYWxfaXB2NH08L3NwYW4+CiAgICAgICAgICAgIDwvZGl2PgogICAgICAgICAgICA8ZGl2IGNsYXNzPSJkZXRhaWwtaXRlbSI+CiAgICAgICAgICAgICAgICA8c3BhbiBjbGFzcz0iZGV0YWlsLWxhYmVsIj5BdmFpbGFiaWxpdHkgWm9uZTo8L3NwYW4+CiAgICAgICAgICAgICAgICA8c3BhbiBjbGFzcz0iZGV0YWlsLXZhbHVlIj4ke2F6fTwvc3Bhbj4KICAgICAgICAgICAgPC9kaXY+CiAgICAgICAgICAgIDxkaXYgY2xhc3M9ImRldGFpbC1pdGVtIj4KICAgICAgICAgICAgICAgIDxzcGFuIGNsYXNzPSJkZXRhaWwtbGFiZWwiPlZQQyBJRDo8L3NwYW4+CiAgICAgICAgICAgICAgICA8c3BhbiBjbGFzcz0iZGV0YWlsLXZhbHVlIj4ke3ZwY308L3NwYW4+CiAgICAgICAgICAgIDwvZGl2PgogICAgICAgIDwvZGl2PgogICAgPC9kaXY+CjwvYm9keT4KPC9odG1sPgpFT0YKCiMgQ2xlYW4gdXAgdGhlIHRlbXAgZmlsZXMKcm0gLWYgL3RtcC9sb2NhbF9pcHY0IC90bXAvYXogL3RtcC9tYWNpZA=="
  user_data = filebase64("user_data_ec2_linux-private.sh")

  # capacity_reservation_specification {
  #   capacity_reservation_preference = "open"
  # }

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  # enclave_options {
  #   enabled = false
  # }

  # maintenance_options {
  #   auto_recovery = "default"
  # }

  # metadata_options {
  #   http_endpoint               = "enabled"
  #   http_protocol_ipv6          = "disabled"
  #   http_put_response_hop_limit = 2
  #   http_tokens                 = "required"
  #   instance_metadata_tags      = "disabled"
  # }

  # monitoring {
  #   enabled = false
  # }

  # I need this to prevent automatic creation of public EIPs
  # network_interfaces {
  #   associate_public_ip_address = false
  #   delete_on_termination       = true
  #   device_index                = 0
  #   security_groups             = [aws_security_group.lb-tg-ec2.id, aws_security_group.ssh.id]
  # }

  vpc_security_group_ids = [aws_security_group.lb-tg-ec2.id, aws_security_group.ssh.id]


  # private_dns_name_options {
  #   enable_resource_name_dns_a_record    = false
  #   enable_resource_name_dns_aaaa_record = false
  #   hostname_type                        = "ip-name"
  # }

  tag_specifications {
    resource_type = "instance"
    tags = {
      "Company"      = "LHJ"
      "LeadEngineer" = "Lonnie Hodges"
      "Name"         = "asg-launched-private-linux-ec2"
    }
  }
}
