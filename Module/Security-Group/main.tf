
#Create security group for application lb
resource "aws_security_group" "alb_security_group" {
  name        = "ec2/alb security group"
  description = "Security group for ALB"
  vpc_id = var.vpc_id

  ingress {
    description = "HTTP from ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
   ingress {
    description = "HTTPS from ALB"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
   }

   egress {
    description = "HTTP to ALB"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
      Name = "ec2/alb security group"
    }

  
}