provider "aws" {
    alias = us-west-1
    region = us-west-1
}

provider "aws" {
    alias = us-east-1
    region = us-east-1
}

resource "aws_ec2" "myserver" {
    ami_id = "ami-xxxx"
    instance_type = "t2.micro"
    provider = "aws.us-east-1"
}

resource "aws_ec2" "myserver" {
    ami_id = "ami-xxxx"
    instance_type = "t2.micro"
    provider = "aws.us-west-1"
}