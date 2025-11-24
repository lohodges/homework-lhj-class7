# AWS Highly Available Web Application Infrastructure

A production-ready Terraform configuration that deploys a highly available web application infrastructure on AWS with auto-scaling, load balancing, and multi-AZ deployment.

## Architecture

This infrastructure creates a complete 3-tier network architecture in AWS `us-east-2` region:

```
Internet
    │
    ↓
Application Load Balancer (Public Subnets)
    │
    ↓
Auto Scaling Group (3-6 instances)
    │
    ↓
EC2 Instances (Private Subnets across 3 AZs)
    │
    ↓
NAT Gateway → Internet Gateway
```

### Key Components

- **VPC**: Custom VPC (10.53.0.0/16) with DNS support
- **Subnets**:
  - 3 Public subnets (10.53.1-3.0/24) across us-east-2a, 2b, 2c
  - 3 Private subnets (10.53.11-13.0/24) across us-east-2a, 2b, 2c
  - 1 Database subnet (10.53.101.0/24) reserved for future RDS deployment
- **Load Balancer**: Application Load Balancer with HTTP listener (port 80)
- **Auto Scaling**:
  - Min: 3 instances
  - Max: 6 instances
  - Desired: 3 instances
  - Target CPU: 50% utilization
- **Compute**: Amazon Linux 2023 t2.micro instances with Apache httpd
- **Networking**:
  - Internet Gateway for public subnet internet access
  - NAT Gateway with Elastic IP for private subnet outbound traffic
- **Security**: Layered security groups with least-privilege access

## Prerequisites

1. **AWS Account** with appropriate permissions to create VPC, EC2, ALB, and networking resources
2. **Terraform** >= 1.0 (tested with AWS provider 6.18.0)
3. **AWS CLI** configured with credentials
4. **SSH Key Pair** for EC2 instance access:
   ```bash
   ssh-keygen -t ed25519 -f id_ed25519_aws_ec2 -C "AWS EC2 Key"
   ```

## Quick Start

### 1. Clone and Navigate
```bash
cd /path/to/this/directory
```

### 2. Generate SSH Keys
```bash
ssh-keygen -t ed25519 -f id_ed25519_aws_ec2 -C "AWS EC2 Key"
# Press Enter for no passphrase or add one for security
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```

Type `yes` when prompted to confirm deployment.

### 6. Access Your Application
After deployment completes (5-10 minutes), get the load balancer URL:
```bash
terraform output load_balancer_url
```

Visit the URL in your browser to see the web application displaying instance metadata.

## Configuration Files

| File | Purpose |
|------|---------|
| `100-auth.tf` | AWS provider configuration and default tags |
| `101-vpc.tf` | VPC definition |
| `102-subnets.tf` | Public, private, and database subnets |
| `103-igw.tf` | Internet Gateway |
| `104-nat.tf` | NAT Gateway and Elastic IP |
| `105.rtb.tf` | Route tables and associations |
| `106-sg.tf` | Security groups for SSH, HTTP/HTTPS, LB, and EC2 |
| `107-ec2.tf` | EC2 key pairs and AMI data sources |
| `108-lb-asg-lt.tf` | Load balancer, target group, auto-scaling group, and launch template |
| `9999-output.tf` | Terraform outputs |

## Customization

### Change Region
Edit `100-auth.tf` and update the region:
```hcl
provider "aws" {
  region = "us-west-2"  # Change to your preferred region
}
```

### Modify Instance Count
Edit `108-lb-asg-lt.tf`:
```hcl
resource "aws_autoscaling_group" "front-end" {
  min_size         = 2  # Minimum instances
  max_size         = 10 # Maximum instances
  desired_capacity = 4  # Starting instances
  # ...
}
```

### Change Instance Type
Edit `108-lb-asg-lt.tf`:
```hcl
resource "aws_launch_template" "ec2-linux-private" {
  instance_type = "t3.small"  # Change from t2.micro
  # ...
}
```

### Update SSH Allowed IP
Edit `106-sg.tf` to allow SSH from your IP:
```hcl
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  cidr_ipv4 = "YOUR.IP.ADDRESS/32"  # Replace with your IP
  # ...
}
```

### Customize Default Tags
Edit `100-auth.tf`:
```hcl
provider "aws" {
  default_tags {
    tags = {
      ManagedBy    = "Terraform"
      LeadEngineer = "Your Name"
      Company      = "Your Company"
      Environment  = "Production"
    }
  }
}
```

## Outputs

After deployment, the following outputs are available:

```bash
terraform output                    # Show all outputs
terraform output load_balancer_url  # Get ALB DNS name
terraform output ami_id            # Get AMI ID being used
```

## Security Considerations

- **SSH Access**: Currently restricted to IP `xx.xx.xx.xx/32`. Update this in `106-sg.tf` to your IP address.
- **Private Keys**: The SSH private key (`id_ed25519_aws_ec2`) is gitignored and should NEVER be committed.
- **State Files**: Terraform state files contain sensitive data and are gitignored. Consider using remote state (S3 + DynamoDB) for team environments.
- **HTTPS**: This configuration uses HTTP only. For production, configure HTTPS with ACM certificates.
- **Secrets**: No secrets are stored in code. All sensitive data is in gitignored files or fetched at runtime.

## High Availability Features

- **Multi-AZ Deployment**: EC2 instances spread across 3 availability zones
- **Auto Scaling**: Automatically replaces unhealthy instances
- **Load Balancer Health Checks**: Monitors instance health every 10 seconds
- **ELB Health Check Type**: ASG uses ELB health checks to replace failing instances
- **Target Tracking Scaling**: Maintains 50% CPU utilization across instances

## Disaster Recovery

### Backup State
```bash
# Backup your state file before major changes
cp terraform.tfstate terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
```

### Destroy Infrastructure
To tear down all resources:
```bash
terraform destroy
```

**Warning**: This will delete all resources. Ensure you have backups of any data.

## Troubleshooting

### Common Issues
**Issue**: Website not loading
- **Solution**: Wait 2-3 minutes after deployment for instances to pass health checks. Check ASG instances are "InService"

### Debug Commands
```bash
# View current state
terraform show

# List all resources
terraform state list

# Show specific resource details
terraform state show aws_lb.front-end

# Validate configuration
terraform validate

# Check formatting
terraform fmt -check
```

## Monitoring

Access AWS Console to monitor:
- **EC2 → Auto Scaling Groups**: View instance health and scaling activity
- **EC2 → Load Balancers**: Monitor target health and request metrics

## Author

**Lonnie Hodges** - Lead Engineer, LHJ

## Acknowledgments

- AWS Terraform Provider Documentation
- AWS Well-Architected Framework
- HashiCorp Terraform Best Practices
