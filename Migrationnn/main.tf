provider "aws" {
  region = "us-east-1"
}

import {
  to = aws_instance.example
  id = "i-0f81f011c1ea33ea9"
}

