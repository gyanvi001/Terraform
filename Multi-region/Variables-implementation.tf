variable "ami_id" {
    description = "AMI ID for instance"
    type = string
    default = "ami-0c55b159cbfafe1f0" 
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
    id = var.ami_id # Example AMI ID, replace with
    instance_type = var.instance_type

}

#Outputthe value 

output "public_ip" {
 description = "The public-ip of ec2 server is "
 value = aws_instance.server.public_ip

}