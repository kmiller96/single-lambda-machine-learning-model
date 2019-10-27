provider "aws" {
    profile = "default"
    region = "ap-southeast-2"
}


resource "aws_s3_bucket" "bucket" {
    bucket = var.bucket_name
    acl = "private"
}