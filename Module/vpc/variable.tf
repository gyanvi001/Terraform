variable region {
  description = "The AWS region to deploy the VPC in"
  type        = string
  default     = "us-east-1"
}

variable project_name {
  description = "The name of the VPC"
  type        = string
  default     = "my-vpc"
}

variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_subnet_az1_cidr" {}
variable "private_subnet_az2_cidr" {}
variable "secure_subnet_az1_cidr" {}
variable "secure_subnet_az2_cidr" {}