variable "ami_id" {
    description = "AMI ID for instance"
    type = string
}

variable "instance_type" {
    description = "Type for instance"
    type = string
    default = "t2.micro"
}


provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "server" {
    ami_id = var.ami_id
    instance_type = var.instance_type

}

#Outputthe value 

output "public_ip" {
 description = "The public-ip of ec2 server is "
 value = aws_instance.server.public_ip

}