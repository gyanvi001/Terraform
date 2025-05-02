<<<<<<< HEAD
3Multi-Region
=======
3Multi-Region
>>>>>>> ff219b3 (Modified)

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


#Multi-provider
module "aws_vpc" {
    source = "./aws_vpc"
    providers = {
        aws = aws.us-west-2
    }
}


# -------------------------
# Define Required Providers
# -------------------------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3"
}