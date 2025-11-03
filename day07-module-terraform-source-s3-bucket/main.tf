module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "module-bucket-source-terrafrom3rdnov"
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}