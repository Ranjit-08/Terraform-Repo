variable "subnet1_id" {
  description = "First subnet ID for the RDS subnet group"
  type        = string
}

variable "subnet2_id" {
  description = "Second subnet ID for the RDS subnet group"
  type        = string
}

variable "instance_class" {
  description = "Instance class for the RDS instance (e.g., db.t3.micro)"
  type        = string
}

variable "db_name" {
  description = "Name of the initial database to create"
  type        = string
}

variable "db_user" {
  description = "Master username for the database"
  type        = string
}

variable "db_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

