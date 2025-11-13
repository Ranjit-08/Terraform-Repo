################vpc-module######################
module "vpc" {
  source       = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
    subnet1_cidr = var.subnet1_cidr
    subnet2_cidr = var.subnet2_cidr
    az1          = var.az1
    az2          = var.az2
}
################ec2-module######################
module "ec2" {
  source = "./modules/ec2"
    ami  = var.ami_id
    type = var.instance_type
    subnet_id     = module.vpc.subnet1_id
}
################rds-module######################
module "rds" {
  source         = "./modules/rds"
  subnet1_id      = module.vpc.subnet1_id
  subnet2_id      = module.vpc.subnet2_id
  instance_class = var.rds_instance_class
  db_name        = var.db_name
  db_user        = var.db_user
  db_password    = var.db_password
}
################s3-module######################
module "s3" {
  source = "./modules/s3"
    bucket_name = var.s3_bucket_name
}