variable "ami" {
  description = "the value is passing from the tfvars file"
  default = ""
  type  = string
}
variable "instance_type" {
    description = "the value is passing from the tfvars file"
    default = ""
    type  = string
  
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}
