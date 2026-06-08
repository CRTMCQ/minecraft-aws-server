# Automated Minecraft Server Deployment

This project follows Infrastructure as Code (IaC) principles to automate the provisioning and configuration of a Minecraft server hosted on AWS infrastructure.


## Required Tools

- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) (with valid AWS credentials configured)


## SSH Setup

SSH access is intended for automated configuration and administrative use only.

A key pair is required to SSH into the server instance. Use an existing SSH key pair or generate a new one with ```ssh-keygen```:

```
ssh-keygen -t ed25519 -f <YOUR_PATH_AND_NAME_HERE>
```

The Terraform configuration imports the public key (```.pub```) into AWS while the private key remains on the local machine.

The allowed SSH CIDR block is stored locally in ```terraform.tfvars``` as the ```ssh_cidr_ipv4``` variable. This prevents network information from being committed to version control with ```terraform.tfvars``` excluded through ```.gitignore```.

Create a local ```terraform.tfvars``` file in the project directory with the following content:

```
ssh_cidr_ipv4       = "YOUR.PUBLIC.IP.ADDRESS/32"
ssh_public_key_path = "YOUR_PATH_TO_PUBLIC_KEY.pub"
```

#######################

Setup hosts.ini file

Ansible

 - may require manual SSH from WSL / Ansible control node to instance at least once to establish known hosts



References
 - Safer shutdown settings https://kibitkin.info/minecraft-systemd-autostart/
 - Creating Ansible hosts.ini file https://oneuptime.com/blog/post/2025-12-18-create-ansible-inventory-from-terraform/view 


May need to manually SSH connect from the ansible control node to accept the new host key on first time around


Pipeline
 - WSL Ubuntu control machine
    - AWS CLI
    - Terraform
    - Ansible
    - SSH Keys
---->
 - AWS EC2 Ubuntu instance
---->
 - Minecraft server managed by systemd



 Deployment Process
 ```
 terraform apply
 ansible-playbook -i hosts.ini deploy.yml
 ```
