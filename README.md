# AWS Minecraft Server Automation

## Background

The goal of this project is to use scripts to automate the provisioning, configuration, and deployment of a Minecraft server on AWS infrastructure. These scripts handle the entire process through code without requiring any manual interaction with the AWS Management Console.

Terraform is used to provision AWS resources, namely an EC2 instance, security group, and key pair resource. It also dynamically generates the ```hosts.ini``` file used by Ansible to connect to the instance.

Ansible configures the instance by installing Java, downloading the Minecraft server files, and configuring the server as a systemd service. The service is configured to cleanly shutdown and automatically restart when the EC2 instance reboots.

This project was developed on Windows 11 using WSL Ubuntu as a Linux environment.


## Requirements

### Required Tools

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Ansible](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html)


### AWS Credentials

Valid AWS credentials must be configured locally before running Terraform. This is what allows Terraform to actually make API calls to AWS.

```
aws configure
```


### SSH Key Setup

An SSH key pair is required for Ansible to connect to and configure the server instance, while Terraform uses the public key to provision an AWS key pair resource.

Use an existing key or generate a new one:

```
ssh-keygen -t ed25519 -f ~/.ssh/minecraft-server-key
```


### Terraform Variables

Create a new file named ```terraform.tfvars``` inside the ```terraform/``` directory, replacing the placeholder values:

```
ssh_cidr_ipv4        = "YOUR.PUBLIC.IP.ADDRESS/32"
ssh_private_key_path = "YOUR_PRIVATE_KEY_PATH"
ssh_public_key_path  = "YOUR_PUBLIC_KEY_PATH.pub"

```

```ssh_cidr_ipv4``` is the public IPv4 address/CIDR block thta is allowed to SSH into the EC2 instance. Note that ```/32``` restricts access to a single address and should be changed if an address range is desired.

```ssh_private_key_path``` is the path to the SSH private key stored on the local machine. Terraform uses this path to generate the ```ansible/hosts.ini``` file for later Ansible connectivity.

```ssh_public_key_path``` is the path to the SSH public key that will be used by Terraform to provision the AWS key pair resource. Make sure to include the ```.pub``` file extension.

> **Note:**
> ```terraform.tfvars``` is excluded through ```.gitignore```, with all values remaining on the local machine. Terraform only uses this file to configure local values during initial provisioning and configuration, acting as an alternative method to setting up local environment variables.



## Pipeline Diagram

![Pipeline Diagram](images/pipeline_diagram.png)



## Commands to Run

Initialize and apply Terraform to provision the AWS EC2 instance, security group, and key pair resources:
```
cd terraform
terraform init
terraform apply
```

After running ```terraform apply```, the public IPv4 address of the new EC2 instance is output to the terminal. Be sure to note this down for later server connectivity.

Terraform also generates the ```ansible/hosts.ini``` file using the instance's public IP address and the supplied SSH private key path. This file is then used by Ansible to connect to the EC2 instance automatically.

Run the Ansible ```deploy.yml``` playbook to deploy and configure the Minecraft server:
```
cd ../ansible
ansible-playbook -i hosts.ini deploy.yml
```

The playbook installs Java, downloads Minecraft server files, accepts the required EULA, starts the Minecraft server, and configures the ```minecraft``` systemd service for automatic startup on reboot.


## Connecting to the Minecraft Server

Once the Ansible playbook completes, you can connect through the Minecraft launcher and adding a new multiplayer server. For the address, use the EC2 public IPv4 address output by Terraform in the terminal earlier like so: ```YOUR.INSTANCE.PUBLIC.IP:25565```.

Connection can also be tested without launching the actual game:
```
nmap -sV -Pn -p T:25565 <SERVER_PUBLIC_IP>
```


## Resources / Sources

 - [Terraform Tutorial: Get Started - AWS](https://developer.hashicorp.com/terraform/tutorials/aws-get-started)

 - [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

 - [Ansible Documentation](https://docs.ansible.com/projects/ansible/latest/getting_started/index.html)

 - [Official Minecraft Java Server Download Page](https://www.minecraft.net/en-us/download/server)

 - [Safer systemd Shutdown Settings](https://kibitkin.info/minecraft-systemd-autostart/)

 - [Minecraft systemd Service Example](https://www.shells.com/l/en-US/tutorial/0-A-Guide-to-Installing-a-Minecraft-Server-on-Linux-Ubuntu)

 - [How to Create Ansible Inventory from Terraform](https://oneuptime.com/blog/post/2025-12-18-create-ansible-inventory-from-terraform/view)

 
