#create VPC
resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }   
}
#Create Subnet
resource "aws_subnet" "name" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
    tags = {
        Name = "public-subent-1"
    }   
}
#create private subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
    availability_zone = "us-east-1b"
        tags = {
            Name = "private-subent-1"
        }
}
#Create Internet Gateway        
resource "aws_internet_gateway" "name" {
  vpc_id = aws_vpc.name.id
    tags = {
        Name = "my-igw"
    }   
}
#Create Route Table
resource "aws_route_table" "name" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.name.id
  }

  tags = {
    Name = "my-route-table"
  }
}

#Associate Route Table with Subnet
resource "aws_route_table_association" "name" {
  subnet_id      = aws_subnet.name.id
  route_table_id = aws_route_table.name.id
}
#Create Security Group
resource "aws_security_group" "name" {
  name        = "my-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.name.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
    from_port   = 80
    to_port     = 80        
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "my-sg"
    }   
}
#Create EC2 Instance
resource "aws_instance" "name" {
  instance_type = "t3.micro"
  ami           = "ami-07860a2d7eb515d9a"
  subnet_id     = aws_subnet.name.id
  vpc_security_group_ids = [aws_security_group.name.id]
  associate_public_ip_address = true
    tags = {
        Name = "public-ec2"
    }   
}
#create EC2 Instance in private subnet
resource "aws_instance" "private_instance" {    
    instance_type = "t3.micro"
    ami           = "ami-07860a2d7eb515d9a"
    subnet_id     = aws_subnet.private.id
    vpc_security_group_ids = [aws_security_group.name.id]
        tags = {
            Name = "private-ec2"
        }   
}

#elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
    tags = {
        Name = "nat-eip"
    }   
}
#create NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.name.id
    tags = {
        Name = "nat-gateway"
    }   
}
#Create Route Table for private subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.name.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
    }
    tags = {
        Name = "private-rt"
    }
}
#Associate private route table with private subnet
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

