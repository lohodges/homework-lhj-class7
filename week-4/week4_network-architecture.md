# Assignment: Network Architecture
## Week 4
### You must create your own Network architecture with at least 3 public Subnets and 6 private subnets. Upload your network range in a document. Network architecture must include subnet masks and the AWS region it was designed for. The network architecture should be able to be utilized for building a VPC within the console.

**AWS Resource:**
VPC

**Region:**
eu-west-1

**AZ (all available as of 2025-11-01)**
eu-west-1a
eu-west-1b
eu-west-1c

**Network**
CIDR: 10.43.0.0/16
Subnet mask:  /16 or 255.255.0.0

| Subnet Name    | Type    | AZ         | CIDR Block     | Subnet Mask         | Purpose                     |
| -------------- | ------- | ---------- | -------------- | ------------------- | --------------------------- |
| public-1a      | public  | eu-west-1a | 10.43.1.0/24   | 255.255.255.0 (/24) | General use, bastion server |
| public-1b      | public  | eu-west-1b | 10.43.2.0/24   | 255.255.255.0 (/24) | General use                 |
| public-1c      | public  | eu-west-1c | 10.43.3.0/24   | 255.255.255.0 (/24) | General use                 |
| private-1a-app | private | eu-west-1a | 10.43.11.0/24  | 255.255.255.0 (/24) | internal apps               |
| private-1b-app | private | eu-west-1b | 10.43.12.0/24  | 255.255.255.0 (/24) | internal apps               |
| private-1c-app | private | eu-west-1c | 10.43.13.0/24  | 255.255.255.0 (/24) | internal apps               |
| private-1a-db  | private | eu-west-1a | 10.43.101.0/24 | 255.255.255.0 (/24) | database                    |
| private-1b-db  | private | eu-west-1b | 10.43.102.0/24 | 255.255.255.0 (/24) | database                    |
| private-1c-db  | private | eu-west-1c | 10.43.103.0/24 | 255.255.255.0 (/24) | database                    |
|                |         |            |                |                     |                             |
