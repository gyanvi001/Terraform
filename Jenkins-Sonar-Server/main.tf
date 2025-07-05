provider "aws" {
  region = var.aws_region
}

resource "aws_instance"  "Jenkins-Server" {
    ami = var.ami_id # EC2 instance ID for Ubuntu 
    instance_type = var.instance_type # EC2 instance type
    key_name = var.key_name # Key pair name for SSH access
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id] # Security group for Jenkins

    user_data = file("user_data.sh")

    root_block_device {
    volume_size = 20 # Resize root volume to 20 GB
    volume_type = "gp2"
   }

    tags = {
        Name = "Jenkins-Server"
    }

}

resource "aws_instance"  "Jenkins-Agent" {
    ami = var.ami_id # EC2 instance ID for Ubuntu 
    instance_type = var.instance_type # EC2 instance type
    key_name = var.key_name # Key pair name for SSH access
    vpc_security_group_ids = [aws_security_group.jenkins_sg.id] # Security group for Jenkins

    user_data = file("agent_user_data.sh")

    root_block_device {
    volume_size = 10 # Resize root volume to 10 GB
    volume_type = "gp2"
   }

    tags = {
        Name = "Jenkins-Agent"
    }

}


resource "aws_security_group" "jenkins_sg" {
    name = "jenkins_sg"
    description = "Security group for Jenkins server"

    ingress {
        from_port  = 22
        to_port   = 22
        protocol  = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port  = 8080
        to_port    = 8080
        protocol   = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

      ingress {
        from_port  = 9000
        to_port    = 9000
        protocol   = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
}
