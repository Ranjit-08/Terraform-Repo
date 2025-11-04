resource "aws_vpc" "name" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "dev"
  }
}

resource "aws_subnet" "subnet-1" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet-2" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_db_subnet_group" "sub-grp" {
  name       = "mycutsubnett"
  subnet_ids = [
    aws_subnet.subnet-1.id,
    aws_subnet.subnet-2.id
  ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage             = 10
  identifier                    = "book-rds"
  db_name                       = "mydb"
  engine                        = "mysql"
  engine_version                = "8.0"
  instance_class                = "db.t3.micro"

  manage_master_user_password   = true
  username                      = "admin"

  db_subnet_group_name          = aws_db_subnet_group.sub-grp.name
  parameter_group_name          = "default.mysql8.0"

  backup_retention_period       = 7
  backup_window                 = "02:00-03:00"
  maintenance_window            = "sun:04:00-sun:05:00"

  deletion_protection           = false
  skip_final_snapshot           = true

  # ✅ Ensures subnet group & subnets & vpc are created first 
 depends_on = [ aws_vpc.name ,
 aws_db_subnet_group.sub-grp,
 aws_subnet.subnet-1 ,
 aws_subnet.subnet-2 ,
  ]
}
