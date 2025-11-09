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
		- https://code.visualstudio.com/
			- Follow the directions for your OS
		- https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform
			- After you have installed VS Code, install the extension by following the directions at the link above or go to the Extensions tab in VS Code to search for and install the HashiCorp Terraform extension.
	- Neovim with Terraform plugin
		- If you are using Neovim, you know what you are doing or you know that the learning curve is steep. Good luck! I will switch eventually to Neovim.
	- any \*NIX terminal text editor (nano, vim, vi)
		- Read the man pages for any of these tools if you need help.
	- Notepad++
		- https://notepad-plus-plus.org/downloads/
	- Windows Notepad
		- If you like to punish yourself, use Windows Notepad; otherwise, I recommend Notepad++.
- Terraform CLI
- AWS Account
- AWS CLI
	- Read AWS-CLI-setup.md [AWS-CLI-setup](AWS-CLI-setup.md)
- Git Bash (Windows only) - Linux and Unix are the operating systems (OS) that you will encounter the most in the Cloud. You need to get familiar with commands in primarily Linux systems. 
	- https://gitforwindows.org/
		- Git for Windows focuses on offering a lightweight, native set of tools that bring the full feature set of the [Git SCM](https://git-scm.com/) to Windows while providing appropriate user interfaces for experienced Git users and novices alike.
		- Git BASH
			- Git for Windows provides a BASH emulation used to run Git from the command line. *NIX users should feel right at home, as the BASH emulation behaves just like the “git” command in LINUX and UNIX environments.
1. Make sure this command produces something similar below:  aws sts get-caller-identity
	1. ![](../attachments/Pasted%20image%2020251108111059.png)
2. https://developer.hashicorp.com/terraform/install
	1. Follow install instructions for your OS.
3. In your terminal, confirm installation of Terraform by typing terraform -v. You should see Terraform and a version number.
	1. ![](../attachments/Pasted%20image%2020251108074207.png)
4. Make a working directory for your Terraform code and cd into it
5. Create at least one file with extension ".tf". You call it whatever you want, but I recommend following the Terraform Style Guide
	1. Optional: if you want a good starting point for directory and files organization, you can clone this repo:  https://github.com/aaron-dm-mcdonald/Class7-notes/tree/main/110225
		1. ![](../attachments/Pasted%20image%2020251109094505.png)
6. Create your AWS infrastructure (you can use GCP or Azure)
	1. AWS ClI must be installed and authenticated
	2. Add a provider block for AWS. If you are using Aaron's files, the provider block is already in 0-auth.tf.
	
     ![](../attachments/Pasted%20image%2020251108084521.png)
7. Run terraform init in the terminal
	1. It will create a .terraform directory and .terraform.lock.hcl. There is never a need to touch those files unless you know what you are doing; even then, I would avoid them.
		1. The dependency lock file is a file that belongs to the configuration as a whole, rather than to each separate module in the configuration. For that reason Terraform creates it and expects to find it in your current working directory when you run Terraform, which is also the directory containing the .tf files for the root module of your configuration. The lock file is always named .terraform.lock.hcl, and this name is intended to signify that it is a lock file for various items that Terraform caches in the .terraform subdirectory of your working directory.  Terraform automatically creates or updates the dependency lock file each time you run the terraform init command. You should include this file in your version control repository so that you can discuss potential changes to your external dependencies via code review, just as you would discuss potential changes to your configuration itself.
8. Create a .gitgnore file. 
	1. Copy Aaron's: https://github.com/aaron-dm-mcdonald/Class7-notes/blob/main/110225/.gitignore
	2. ![](../attachments/Pasted%20image%2020251108113221.png)
9. 