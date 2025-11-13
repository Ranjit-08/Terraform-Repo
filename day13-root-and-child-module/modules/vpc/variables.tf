variable "vpc_cidr" {
    description = "The CIDR block for the VPC"
    type        = string
}
variable "subnet1_cidr" {
    description = "The CIDR block for the subnet1"
    type        = string
}
variable "subnet2_cidr" {
    description = "The CIDR block for the subnet2"
    type        = string
  
}
variable "az1" {
    description = "The availability zone for subnet1"
    type        = string
}
variable "az2" {
    description = "The availability zone for subnet2"
    type        = string
  
}