provider "aws" {
  region = "ap-south-1"
}

#import {
#  to = aws_instance.example
 # id = "i-0f81f011c1ea33ea9"
#}

resource "aws_s3_bucket" "new-backend-bucket" {
  bucket = "new-my-terraform-backend-bucket"
  tags = {
    Name        = "My Terraform Backend Bucket"
    Environment = "Dev"
  }
}
 
resource "aws_s3_bucket_versioning" "bucket-versioning" {
  bucket = aws_s3_bucket.new-backend-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
  lifecycle {
    prevent_destroy = false
  }

}

resource "aws_dynamodb_table" "terraform_state_dynamo" {
  name = "my-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}