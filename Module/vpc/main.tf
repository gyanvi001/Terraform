provider "aws" {
    region = var.region
}


## Create a VPC with the specified CIDR block and enable DNS support and hostnames
resource "aws_vpc" "infra" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    instance_tenancy = "default"
    

    tags = {
        Name = "${var.project_name}-vpc"
      }
  
}

## Create a internet gateway and attach it to the VPC
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.infra.id
    tags = {
        Name = "${var.project_name}-igw"
    }
}
    

data "aws_availability_zones" "available_zone" {}

#Create a public subnet in the first availability zone
resource "aws_subnet" "public_subnet_az1" {
    vpc_id = aws_vpc.infra.id
    availability_zone = data.aws_availability_zones.available_zone.names[0]
    cidr_block = var.public_subnet_az1_cidr
    map_public_ip_on_launch = true
     tags      = {
       Name    = "public subnet az1"
      }
}

#Create a public subnet az2 in the second availability zone
resource "aws_subnet" "public_subnet_az2" {
    vpc_id = aws_vpc.infra.id
    availability_zone = data.aws_availability_zones.available_zone.names[1]
    cidr_block = var.public_subnet_az2_cidr
    map_public_ip_on_launch = true
     tags      = {
       Name    = "public subnet az2"
      }
}

#Create a route table for the public subnet
resource "aws_route_table" "public_route_table" {
    vpc_id = aws_vpc.infra.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
          
        }

    tags = {
        Name = "public-route-table"
    }
}

#Associate the public route table with the public subnet az1
resource "aws_route_table_association" "public_subnet_az1_association" {
    subnet_id = aws_subnet.public_subnet_az1.id
    route_table_id = aws_route_table.public_route_table.id
}

#Associate the public route table with the public subnet az2
resource "aws_route_table_association" "public_subnet_az2_association" {
    subnet_id = aws_subnet.public_subnet_az2.id
    route_table_id = aws_route_table.public_route_table.id
}

#Create a private subnet in the first availability zone
resource "aws_subnet" "private_subnet_az1" {
    vpc_id = aws_vpc.infra.id
    availability_zone = data.aws_availability_zones.available_zone.names[0]
    cidr_block = var.private_subnet_az1_cidr
    tags = {
        Name = "private subnet az1"
    }
}

#Create a private subnet in the second availability zone
resource "aws_subnet" "private_subnet_az2" {
    vpc_id = aws_vpc.infra.id
    availability_zone = data.aws_availability_zones.available_zone.names[1]
    cidr_block = var.private_subnet_az2_cidr
    tags = {
        Name = "private subnet az2"
    }
}

# create secure subnet az1
resource "aws_subnet" "secure_subnet_az1" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.secure_subnet_az1_cidr
  availability_zone        = data.aws_availability_zones.available_zone.names[0]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "secure subnet az1"
  }
}

# create secure subnet az2
resource "aws_subnet" "secure_subnet_az2" {
  vpc_id                   = aws_vpc.infra.id
  cidr_block               = var.secure_subnet_az2_cidr
  availability_zone        = data.aws_availability_zones.available_zone.names[1]
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "secure subnet az2"
  }
}