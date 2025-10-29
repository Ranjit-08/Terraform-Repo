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
  description = "cidr of ranjit vpc"
  type=string
}