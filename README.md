# Automated Minecraft Server Deployment

This project follows Infrastructure as Code (IaC) principles to automate the provisioning and configuration of a Minecraft server hosted on AWS infrastructure.


## Required Tools

- Terraform
- AWS CLI (with valid AWS credentials configured)


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

