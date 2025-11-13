resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "day13-vpc"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet1_cidr
  availability_zone = var.az1
  tags = {
    Name = "day13-subnet1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.subnet2_cidr
  availability_zone = var.az2
  tags = {
    Name = "day13-subnet2"
  }
}

# ✅ Outputs
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}
