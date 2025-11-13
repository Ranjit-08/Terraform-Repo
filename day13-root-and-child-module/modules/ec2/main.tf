resource "aws_instance" "name" {
  ami = var.ami
  instance_type = var.type
  subnet_id = var.subnet_id
  tags = {
    Name = "day13-instance"
  }
}
output "ec2-ID" {
  value = aws_instance.name.id
}