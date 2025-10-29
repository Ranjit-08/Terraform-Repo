resource "aws_instance" "name" {
    instance_type = var.instance_type
    ami           = var.ami
  tags = {
    Name="my-ec2"
  }
}
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    Name="ranjit_vpc"
  }
}