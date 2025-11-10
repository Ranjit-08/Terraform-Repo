########################################
# 1) EC2 SECURITY GROUP (Allows SSH)
########################################
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow SSH access"
  vpc_id      = "vpc-019764ec0a76fec1c"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # (You can replace with your IP)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# 2) RDS SECURITY GROUP (Allow only EC2)
########################################
resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Allow MySQL from EC2"
  vpc_id      = "vpc-019764ec0a76fec1c"

  ingress {
    description     = "MySQL from EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]  # Allow only EC2 instance
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

########################################
# 3) RDS SUBNET GROUP (Requires 2 Subnets)
########################################
resource "aws_db_subnet_group" "rds_subnets" {
  name = "rds-subnet-group"

  subnet_ids = [
    "subnet-0d0e6d65f17f3824a",
    "subnet-0b844960977f7e3f7"
  ]

  tags = {
    Name = "RDS Subnet Group"
  }
}

########################################
# 4) RDS INSTANCE
########################################
resource "aws_db_instance" "mysql_rds" {
  identifier            = "ranjit-mysql-db"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "8.0"
  instance_class        = "db.t3.micro"
  publicly_accessible   = false
  skip_final_snapshot   = true

  db_name   = "dev"
  username  = "admin"
  password  = "Ranjit-1234"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name
}

########################################
# 5) KEYPAIR
########################################
resource "aws_key_pair" "example" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

########################################
# 6) EC2 INSTANCE (Runs SQL)
########################################
resource "aws_instance" "sql_runner" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = aws_key_pair.example.key_name

  subnet_id              = "subnet-0d0e6d65f17f3824a"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true   # IMPORTANT

  tags = {
    Name = "SQL Runner"
  }
}

########################################
# 7) REMOTE EXEC (Install MySQL + Run .sql)
########################################
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds, aws_instance.sql_runner]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("~/.ssh/id_ed25519")
    host        = aws_instance.sql_runner.public_ip
  }

  provisioner "file" {
    source      = "init.sql"
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y mysql",
      "mysql -h ${aws_db_instance.mysql_rds.address} -u admin -p\"Ranjit-1234\" dev < /tmp/init.sql"
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}
########################################
# 8) OUTPUTS
output "rds_endpoint" {
  description = "RDS endpoint to connect the database"
  value       = aws_db_instance.mysql_rds.address
}
