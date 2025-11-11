resource "aws_instance" "name" {
  ami="ami-07860a2d7eb515d9a" 
  instance_type = "t3.micro"
  tags = {
    Name = "MultiAccount-Instance"
  }

}

resource "aws_s3_bucket" "name" {
    bucket = "my-multi-account-bucket-ranjit-11nov"
    provider = aws.oregon
}