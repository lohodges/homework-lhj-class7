HW - DELIVERABLES (5 pts)
Must be in github repo link provided to your group leader

Readme.md or <insert_lizzo_here>.txt document of step by step instructions detailing how to set up and initialize Terraform on your computer. Include what programs to use, what programs not to use, what files should or should not be modified, any Github repos to reference, and relevant commands to get the program running. Instructions should be detailed enough to provide to someone else so they can use the instructions.

Screenshot of a successful “terraform apply” within VS Code, Terminal, Git Bash, or Powershell

Screenshot of results from the “aws sts get-caller-identity” command

Screenshot of the .gitignore file in the same folder as your Terraform files

Text document listing at least one person who you shared your instructions with, and they were able to use your instructions to deploy Terraform on their own.

# How to set up Terraform
### Prerequisites
- Text Editor (you choose)
	- VSCode with Terraform extension
	- Neovim with Terraform plugin
	- any terminal text editor (nano, vim, vi)
- Terraform CLI
- AWS CLI
- AWS Account
	- Add user for CLI with permissions "AdministratorAccess", “AmazonAPIGatewayAdministrator”, “SystemAdministrator”
	- Be sure to get your access key and secret access key
1. Make sure this command produces something similar below:  aws sts get-caller-identity
	1. ![](../attachments/Pasted%20image%2020251108111059.png)
2. https://developer.hashicorp.com/terraform/install
	1. Follow install instructions for your OS.
3. In your terminal, confirm installation of Terraform by typing terraform -v. You should see Terraform and a version number.
	1. ![](../attachments/Pasted%20image%2020251108074207.png)
4. Make a working directory for your Terraform code and cd into it
5. Create at least one file with extension .tf. You call it whatever you want, but I recommend following the Terraform Style Guide
6. Create your AWS infrastructure (you can use GCP or Azure)
	1. AWS ClI must be installed and authenticated
	2. Add a provider block for AWS
	
     ![](../attachments/Pasted%20image%2020251108084521.png)
7. Run terraform init in the terminal
	1. It will create a .terraform directory and .terraform.lock.hcl. There is never a need to touch those files unless you know what you are doing; even then, I would avoid them.
8. 




