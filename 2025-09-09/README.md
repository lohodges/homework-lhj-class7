# How to configure EC2

## Create you your Security Group

1. Log into AWS
2. Search for Security Group
3. Click the Create Security button
4. Name your Security Group (no spaces, all lowercase)
5. Enter a description
6. Use the default VPC or your custom VPC.
7. Inbound Rules
	1. click Add rule button
		1. Add Type: HTTP (allows you to connect to a web server through port 80)
		2. Source: Anywhere IPv4
		3. Enter a useful description
	2. Click the Add rule button
		1. Add Type: SSH (allows you to connect to the server over SSH)
		2. Source: Anywhere IPv4
		3. Enter a useful description
8. Outbound Rules - do not make any changes
9. Tags - optional
10. Click the Create security group button

## Create your EC2

1. In the Search bar, search for EC2, and click EC2
2. Click the Launch Instance button
3. Enter Name and tags (optional). No spaces, all lowercase. You can use underscores or dashes
4. Your AMI is Amazon Linux or your preferred flavor of Linux (Class 7 uses Amazon Linux)
5. Instance Type: confirm that you see Free tier eligible. At your job, your employer or coworkers will let you know what to use.
6. Key pair (login) - use an existing key pair, create a new key pair, or proceed without a key pair. You won't be able to use AWS Connect without the key pair.
7. Network Settings: use the default VPC for now.
8. Firewall (security groups): Select existing security group
9. Skip Configure storage
10. Advanced details - copy any desired set up script in User data field
11. Click the Launch Instance button

  

# Teardown of EC2
1. Search for EC2 in the Search bar
2. Click the checkbox next to the instance that you want to Terminate
3. Click the Instance state button > Select Terminate (delete) instance