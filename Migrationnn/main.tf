provider "aws" {
  region = "ap-south-1"
}

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
  name         = "my-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_instance" "My-instance" {
  ami           = "ami-088231783271"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  tags = {
    Name        = "My EC2 Instance"
    Environment = "Dev"
  }

  provisioner "file" {
    source      = "local_file.txt"
    destination = "/home/ubuntu/local_file.txt"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("~/.ssh/my-key-pair.pem")  # Corrected here
      host        = self.public_ip
    }
  }
}

resource "aws_security_group" "My-security-group" {
  name        = "MySecurityGroup"
  description = "Allow SSH and HTTP access"
  ingress {
    from_port = 22
    to_port = 22
    protocol  = "ssh"
    cidr_blocks = ["0.0.0/0"] # Allow SSH from anywhere

  }
  }