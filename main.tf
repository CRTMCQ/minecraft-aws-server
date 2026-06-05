provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "minecraft_server" {
  ami           = var.ami_ubuntu_latest
  instance_type = var.instance_type

  tags = {
    Name = "minecraft_server"
  }
}
