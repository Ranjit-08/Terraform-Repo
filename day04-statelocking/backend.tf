terraform {
  backend "s3" {
    bucket = "tf-statefile-bucket-29thoct"
    key    = "day04/terraform.tfstate"
    use_lockfile = true
    region = "us-east-1"
  }
}