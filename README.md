# Azure VM with Terraform

Ubuntu Server 20.04 VM created with Terraform on Azure Cloud. Public key needs to be added to main.tf file. 
```terraform
public_key = file("mykey.pub")
```
Then you can connect with your VM via SSH and private key:
```linux
ssh -i mykey adminuser@vm_public_ip
```
Additionaly Docker will be istalled on VM via remote exec. 

### SSH key pair generation 

![App Screenshot](https://i.ytimg.com/vi/2HnJFOMewJE/maxresdefault.jpg)

Linux command for keypair generation
```bash
ssh-keygen -t rsa -f mykey
```

**mykey.pub** will be injected to VM \
**mykey** will be used for SSH connection 