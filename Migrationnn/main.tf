provider "aws" {
  region = "ap-south-1"
}

#import {
#  to = aws_instance.example
 # id = "i-0f81f011c1ea33ea9"
#}

resource "aws_s3_bucket" "new-backend-bucket" {
  bucket = "new-my-terraform-backend-bucket" # This is the bucket name through which it will be accessed
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

#provisioner
resource "aws_ec2" "My-instance" {
  ami           = "ami-088231783271"
  instance_type = "t2.micro"
  key_name     =  "my-key-pair"
  root_block_device {
    volume_size = 8 
    volume_type = "gp3"
  }

  tags = {
    Name        = "My EC2 Instance"
    Environment = "Dev"
  }

}

# file provisioner 
provisioner "file" {
  source     = "local_file.txt"
  destination = "/home/ubuntu/local_file.txt"
  connection {
    type        = "ssh"
    user   = "ubuntu"
    key_name = "my-key-pair"
    }
}