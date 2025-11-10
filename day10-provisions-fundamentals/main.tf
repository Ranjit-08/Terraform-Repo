# -------------------------
# Provider
# -------------------------
provider "aws" {
  region = "us-east-1"
}

# -------------------------
# Key Pair (replace with your .pem key name)
# -------------------------
resource "aws_key_pair" "key" {
  key_name   = "mykey"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# -------------------------
# Security Group (Allow SSH + HTTP)
# -------------------------
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow SSH and HTTP"

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
}

# -------------------------
# EC2 Instance
# -------------------------
resource "aws_instance" "web" {
    tags = {
    Name = "web-server"
   }
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t3.micro"
  key_name      = aws_key_pair.key.key_name
  security_groups = [aws_security_group.web_sg.name]

  # -------------------------
  # Provisioners
  # -------------------------
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  provisioner "file" {
    source      = "index.html"
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl restart httpd"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host        = self.public_ip
  }
}

# -------------------------
# Output
# -------------------------
output "web_public_ip" {
  value = aws_instance.web.public_ip
}
