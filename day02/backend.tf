terraform {
  backend "s3" {
    bucket = "tf-statefile-bucket-29thoct"
    key    = "day02/terraform.tfstate"
    region = "us-east-1"
  }
}