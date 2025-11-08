(only assigned on 11.04.25 so this is due at end of week 9)

Find a function to explore and research (it can’t be one we used):

https://developer.hashicorp.com/terraform/language/functions

(The categories/index of functions is in the left pane)

Use the function to manipulate attributes or data you pass to the function as an argument. 

Use an output block to show it in the CLI. Use the terraform console command to explore the command and take screenshots. Include your code and screenshots in a GitHub repository. You may use a partner from your group.

For even more extra credit, use an attribute from a data source from the AWS provider in the registry as the argument for the function.


```
output "windows_password" {

value = rsadecrypt(aws_instance.public-win-bastion.password_data, file("id_rsa_windows_ec2"))

}
```

outputs to get Windows Server password to use in RDP.
![](../attachments/Pasted%20image%2020251108142159.png)