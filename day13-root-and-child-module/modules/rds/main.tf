# Create RDS subnet group — uses 2 subnets from the VPC module
resource "aws_db_subnet_group" "this" {
  name       = "day13-db-subnet-group"
  subnet_ids = [var.subnet1_id, var.subnet2_id]

  tags = {
    Name = "day13-db-subnet-group"
  }
}

# Create the RDS MySQL instance
resource "aws_db_instance" "this" {
  identifier              = "day13-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = var.instance_class
  db_name                 = var.db_name
  username                = var.db_user
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  skip_final_snapshot     = true

  # Optional: Add this if you want to keep RDS private
  publicly_accessible     = false


  tags = {
    Name = "day13-rds-instance"
  }
}

# Outputs
output "rds_endpoint" {
  description = "RDS endpoint address"
  value       = aws_db_instance.this.endpoint
}