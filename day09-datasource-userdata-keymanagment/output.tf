output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.name.public_ip
}

output "instance_public_dns" {
  value = aws_instance.name.public_dns
}
