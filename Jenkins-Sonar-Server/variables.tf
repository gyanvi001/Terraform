variable "aws_region" {
    description = "AWS region to deploy resources"
    type = string
    default = "us-east-1" # Change this to your desired region
}

variable "ami_id" {
    description = "AMI ID for the EC2 instance"
    type = string
    
}

variable "instance_type" {
    description = "EC2 instance type"
    type = string
}

variable "key_name" {
    description = "Key pair name for SSH access"
    type = string
}
