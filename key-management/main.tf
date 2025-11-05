# -------------------------
# Provider Configuration
# -------------------------
provider "aws" {
  region = "us-east-1"   # change region if needed
}
# -------------------------
# Data Source: Fetch Latest Amazon Linux 2 AMI
# This will automatically get the latest AMI ID, so no need to hard-code it
# -------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}
resource "aws_key_pair" "key" {
  key_name   = "mykey"                      # Name that will show in AWS
  public_key = file("~/.ssh/id_ed25519.pub") # Make sure this path is correct
}
# -------------------------
# EC2 Instance
# -------------------------
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.amazon_linux.id   # Using DATA SOURCE
  instance_type = "t3.micro"                     # Updated type to t3.micro

#   # IMPORTANT: Use your existing AWS Console Key Pair Name
#   key_name = "ranjit-key-new"   # <-- change to your key name
#   tags = {
#     Name = "My-EC2-Using-AWS-Console-Key"
#   }
key_name = aws_key_pair.key.key_name # Reference the key pair created above
    tags = {
        Name = "terraform-created-keypair-ec2"
}
}
