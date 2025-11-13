variable "ami" {
    description = "The AMI ID for the EC2 instance"
    type        = string
}
variable "type" {
       description = "The instance type for the EC2 instance"
        type        = string  
}
variable "subnet_id" {
    description = "The subnet ID where the EC2 instance will be launched"
    type        = string
}
