provider "aws" {
  region = "us-west-2"
}

# Create security group
resource "aws_security_group" "minecraft_sg" {
  name        = "minecraft-sg"
  description = "Minecraft server security group"

  tags = {
    Name = "minecraft-sg"
  }
}

# Inbound rule - Allow Minecraft
resource "aws_vpc_security_group_ingress_rule" "allow_minecraft" {
  security_group_id = aws_security_group.minecraft_sg.id
  description       = "Allow Minecraft traffic"

  ip_protocol = "tcp"
  from_port   = 25565
  to_port     = 25565
  cidr_ipv4   = "0.0.0.0/0"
}

# Inbound rule - Allow SSH
resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.minecraft_sg.id
  description       = "Allow SSH traffic"

  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = var.ssh_cidr_ipv4
}

# Outbound rule - Allow all outbound
resource "aws_vpc_security_group_egress_rule" "allow_outbound" {
  security_group_id = aws_security_group.minecraft_sg.id
  description       = "Allow all outbound traffic"

  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# Create key pair resource
resource "aws_key_pair" "minecraft_key" {
  key_name   = "minecraft-aws-server-key"
  public_key = file(var.ssh_public_key_path)

  tags = {
    Name = "minecraft-aws-server-key"
  }
}

# Create the server instance
resource "aws_instance" "minecraft_server" {
  ami                    = var.ami_ubuntu_latest
  instance_type          = var.instance_type
  key_name               = aws_key_pair.minecraft_key.key_name
  vpc_security_group_ids = [aws_security_group.minecraft_sg.id]

  tags = {
    Name = "minecraft_server"
  }
}
