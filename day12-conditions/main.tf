# variable "aws_region" {
#   description = "The region in which to create the infrastructure"
#   type        = string
#   nullable    = false
#   default     = "us-east-1" #here we need to define either us-west-1 or eu-west-2 if i give other region will get error 
#   validation {
#     condition = var.aws_region == "us-east-1" || var.aws_region == "eu-west-1"
#     error_message = "The variable 'aws_region' must be one of the following regions: us-west-2, eu-west-1"
#   }
# }
# provider "aws" {
#   region = var.aws_region
#  }
#  resource "aws_s3_bucket" "dev" {
#     bucket = "statefile-configuresss-12thnov"  
# }

### Example-1
# terraform apply -var="aws_region=ap-south-1" 
#  Error: Invalid value for variable
# │
# │   on main.tf line 1:
# │    1: variable "aws_region" {
# │     ├────────────────
# │     │ var.aws_region is "ap-south-1"
# │
# │ The variable 'aws_region' must be one of the following regions: us-west-2, eu-west-1
#after run this will get error like The variable 'aws_region' must be one of the following regions: us-west-2,│ eu-west-1, so it will allow any one region defined above in conditin block



## Example-2
# variable "create_bucket" {
#   type    = bool
#   default = false
# }

# resource "aws_s3_bucket" "example" {
#   count  = var.create_bucket ? 1 : 0
#   bucket = "my-terraform-example"
# }
# his creates a boolean variable (true or false).
# Default is false.
# So, unless you explicitly pass -var="create_bucket=true", Terraform will treat it as false.
# If var.create_bucket is true → count = 1
# If var.create_bucket is false → count = 0


#### Example-3

variable "environment" {
  type    = string
  default = "prod"
}

resource "aws_instance" "example" {
  count         = var.environment == "prod" ? 3 : 1
  ami           = "ami-07860a2d7eb515d9a"
  instance_type = "t3.micro"

  tags = {
    Name = "example-${count.index}"
  }
}

# #In this case:
# #If var.environment == "prod" → count = 3
# #Else (like dev, qa, etc.) → count = 1
# #terraform apply -var="environment=dev"