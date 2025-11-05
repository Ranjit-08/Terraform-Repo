data "aws_subnet" "name" {
    filter {
      name = "tag:Name"
      values = ["subnet-1"]
    }
  
}
data "aws_ami" "amzlinux" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "name"
    values = [ "amzn2-ami-hvm-*-gp2" ]
  }
             filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
        filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }
}
# data "aws_ami" "amzlinux" {
#   most_recent = true
#   owners = [ "self" ]
#   filter {
#     name = "name"
#     values = [ "frontend-ami" ]
#   }

# }
# ✅ Use existing PUBLIC KEY to create AWS key pair
resource "aws_key_pair" "key" {
  key_name   = "mykey"                      # Name that will show in AWS
  public_key = file("~/.ssh/id_ed25519.pub") # Make sure this path is correct
}
resource "aws_instance" "name" {
    ami=data.aws_ami.amzlinux.id
    instance_type = "t3.micro"
    subnet_id = data.aws_subnet.name.id
    user_data = file("userdata.sh")   # Script to run on launch
    key_name = aws_key_pair.key.key_name # Reference the key pair created above
    tags = {
        Name = "datasource-instance"
    }

}