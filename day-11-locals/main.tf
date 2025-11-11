# Terraform locals are used to store values (variables) inside your Terraform configuration 
# that you want to reuse, simplify, or avoid repeating.

# They do not accept input like variables — instead, they are computed inside Terraform.
# Locals are defined using the locals block and can contain multiple key-value pairs.


locals {
  # A combined name template that avoids repeating code
  project_name = "${var.layer}-${var.env}"   # Example: web-dev

  # Default AWS region
  region = "ap-south-1"

  # Standard tags for all resources
  common_tags = {
    Project     = local.project_name
    Environment = var.env
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "${local.project_name}-bucket"   # → web-dev-bucket

  tags = local.common_tags
}

resource "aws_instance" "demo_server" {
  ami           = "ami-07860a2d7eb515d9a"
  instance_type = "t3.micro"
  region = "us-east-1"

  tags = merge(
    local.common_tags,
    { Name = "${local.project_name}-server" }   # → web-dev-server
  )
}
