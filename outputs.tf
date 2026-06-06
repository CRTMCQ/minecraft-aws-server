output "minecraft_server_public_ip" {
  description = "Minecraft server public IP address"
  value       = aws_instance.minecraft_server.public_ip
}
