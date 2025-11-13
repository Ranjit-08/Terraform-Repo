variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}
variable "subnet1_cidr" {
  description = "CIDR block for subnet1"
  type        = string
  default     = "10.0.1.0/24"
}
variable "subnet2_cidr" {
  description = "CIDR block for subnet2"
  type        = string
  default     = "10.0.2.0/24"
}
variable "az1" {
  description = "Availability zone for subnet1"
  type        = string
  default     = "us-east-1a"
}
variable "az2" {
  description = "Availability zone for subnet2"
  type        = string
  default     = "us-east-1b"
}
#########################################
# EC2 Variables
#########################################
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-07860a2d7eb515d9a" # Amazon Linux 2
}
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.micro"
}
#########################################
# RDS Variables
variable "db_name" {
  description = "Database name"
  type        = string
  default     = "day13db"
}
variable "db_user" {
  description = "Database master username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
  default     = "Password123!"
}
variable "rds_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}
#########################################
# S3 Variables  
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "day13-unique-bucket-13thnov"
}