*Credit to Theo, Aaron, Rob, and others on the Team*

Setup instructions
1. Sign into AWS as the root user
2. In the navigation bar on the upper right, choose your username, and then choose Security credentials.
	1. ![](../attachments/Pasted%20image%2020251109120356.png)
3. Click on “User groups” in the left hand pane
4. Click on “Create group”
	1. Name = CLI_Admin
	2. Attach permissions policies = check off the following 
		1. “AdministratorAccess”
		2. “AmazonAPIGatewayAdministrator”
		3. “SystemAdministrator”
	3. Click on “create group”
	4. Click on “Users” in the left hand pane
5. (Scroll down if needed) click on “Create user”
	1. Name the user “AWSCLI”
	2. Check the box saying “Provide user access…”
	3. Click on “I want to create an IAM user”
	4. Click “custom password” and enter your custom password
		1. Uncheck “Users must create a new password…”
		2. Write the password down in your notepad
		3. Click “Next” when ready
6. Permissions options = add user to group
	1. Select the “CLI_Admin” group
7. Click next, then click “create user”
8. Click on “View user” in the green banner at the top
	1. ![](../attachments/Pasted%20image%2020251109120637.png)
9. On the user page, click on “security credentials
	1. ![](../attachments/Pasted%20image%2020251109120727.png)
10. Scroll down to the “Access keys” section and click on “Create access key”
	1. Click on “Command Line Interface (CLI)” and check the box saying “I understand the above recommendation and want to proceed to create an access key” and press next
	2. Add a description if you want and press “create access key”
	3. Copy the **access key** and **secret access key** to your notepad
		1. MAKE SURE THIS DATA IS SAVED SOMEWHERE; IF YOU LOSE THESE KEYS, THE CLI KEYS HAVE TO BE RECREATED
	4. Click done when finished, then go to your computer’s instructions below

### Windows users
1. Open powershell as admin and run the following commands in powershell, one line at a time
	1. choco upgrade all -y
		1. If there are Chocolatey upgrade issues, go here:  https://docs.chocolatey.org/en-us/choco/troubleshooting/dependency-troubles/
	2. aws configure
		1. You'll then be prompted for the access key and secret access key that you just copied; copy and paste the access key and secret access key in the corresponding areas
		2. Default region name = whichever region you like to work in via AWS. Regions are entered as us-east-1, instead of US East (N. Virginia) 
			1. ![](../attachments/Pasted%20image%2020251109121946.png)
		3. Default output format = json
	3. aws configure
		1. Press enter 4 times to view your current AWS configuration. Output should look something like the below
			1. ![](../attachments/Pasted%20image%2020251109122008.png)

### Mac / Linux users
1. Open Terminal and run the following commands, one line at a time
	1. brew update && brew upgrade
		1. if there are Homebrew upgrade issues, go here: https://docs.brew.sh/Common-Issues
	2. aws configure
		1. You'll then be prompted for the access key and secret access key that you just copied; copy and paste the access key and secret access key in the corresponding areas
		2. Default region name = whichever region you like to work in via AWS. Regions are entered as us-east-1, instead of US East (N. Virginia) 
			1. ![](../attachments/Pasted%20image%2020251109122332.png)
		3. Default output format = json
	3. aws configure
		1. Press enter 4 times to view your current AWS configuration. Output should look something like the below
			1. ![](../attachments/Pasted%20image%2020251109122401.png)
2. If you need to make any changes, rerun the command, press enter when the configuration line is correct, and paste/type wherever the configuration line needs to change
