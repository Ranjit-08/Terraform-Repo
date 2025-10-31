resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }
}
resource "aws_instance" "name" {
  ami = "ami-07860a2d7eb515d9a"
    instance_type = "t3.micro"
    tags = {
      Name = "my-ec2-target-resources"
    }
}

resource "aws_s3_bucket" "name" {
    bucket = "my-unique-bucket-name-29thoct-target-resources"
    
    tags = {
        Name        = "my-s3-bucket-target-resources"
        Environment = "Dev"
    }
  
}