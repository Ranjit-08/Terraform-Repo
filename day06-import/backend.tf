terraform {
  backend "s3" {
    bucket = "tf-statefile-bucket-29thoct"
    key    = "day06/terraform.tfstate"
    #use_lockfile = true # enabling state locking in latest terraform versions
    region = "us-east-1"
    #
  }
}