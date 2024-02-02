output "private_ip" {
  value       = aws_instance.ubuntu.private_ip
  description = "The private ip address of the ubuntu server"
}

output "instance_id" {
  value = aws_instance.ubuntu.id
}

output "instance_name" {
  value = var.name
}

output "volume_id" {
  value = aws_instance.ubuntu.root_block_device.0.volume_id
}