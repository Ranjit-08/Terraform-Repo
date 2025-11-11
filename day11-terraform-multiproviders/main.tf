
# Default provider → us-east-1 (N. Virginia)
provider "aws" {
  region = "us-east-1"
}

# Second provider → ap-south-1 (Mumbai)
provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

# S3 bucket in us-east-1
resource "aws_s3_bucket" "bucket_us" {
  bucket = "my-multi-provider-us"
}

# S3 bucket in ap-south-1
resource "aws_s3_bucket" "bucket_india" {
  provider = aws.mumbai   # <-- VERY IMPORTANT
  bucket   = "my-multi-provider-india"
}
