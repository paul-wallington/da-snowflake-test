provider "aws" {
  profile = "default"
  version = "2.7.0"
  region  = "eu-west-2"
}

resource "aws_s3_bucket" "Output_Area_Json_S3" {
  bucket = "da-wallingtonp-test"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "Output_Area_Json_S3_PABC" {
  bucket                  = aws_s3_bucket.Output_Area_Json_S3.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

