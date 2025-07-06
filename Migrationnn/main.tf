provider "aws" {
  region = "us-east-1"
}

#import {
#  to = aws_instance.example
 # id = "i-0f81f011c1ea33ea9"
#}

resource "aws_s3_bucket" "backend-bucket" {
  bucket = "my-terraform-backend-bucket"
  tags = {
    Name        = "My Terraform Backend Bucket"
    Environment = "Dev"
  }
}
 
resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_S3_bucket.backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
  lifecycle {
    prevent_destroy = false
  }


}