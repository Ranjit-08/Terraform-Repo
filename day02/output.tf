output "ec2_instance_id" {
  value = aws_instance.name.id
}

output "ec2_instance_public_ip" {
  value = aws_instance.name.public_ip
}

output "ec2_instance_public_dns" {
  value = aws_instance.name.public_dns
}

output "instance_private_ip" {
  value = aws_instance.name.private_ip
}
