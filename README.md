# Automated Minecraft Server Deployment

This project follows Infrastructure as Code (IaC) principles to fully automate the entire provisioning and configuration process of a Minecraft server on AWS infrastructure.


## Required Tools

- Terraform
- AWS CLI (with valid AWS credentials configured)


## Configuring SSH

SSH access is intended for automated configuration and admin use only.

The allowed SSH address is stored locally in ```terraform.tfvars``` as the ```ssh_cidr_ipv4``` variable. This is intended to exclude network information from version control through ```.gitignore```.

Create a local ```terraform.tfvars``` file with the following content:

```
ssh_cidr_ipv4 = "YOUR.PUBLIC.IP.CIDR"
```

