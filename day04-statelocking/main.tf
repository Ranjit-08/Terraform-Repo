resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-vpc"
  }
}
resource "aws_instance" "name" {
  instance_type = "t3.micro"
  ami           = "ami-07860a2d7eb515d9a"
  tags = {
    Name = "my-ec2"
  }
}