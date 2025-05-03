
data "aws_availability_zones" "available_zones" {}

#Create security group for db
resource "aws_security_group" "database_security_group" {
    name = "database_security_group"
    description = "Security group for RDS database"
    vpc_id = var.vpc_id

    ingress {
        description = "mysql/aurora access"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [var.alb_security_group_id]
    }

    egress {
        description = "Allow all outbound traffic"
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        }

    tags = {
        Name = "database_security_group"
    }

}

#Create subnet group for the rds
resource "aws_db_subnet_group" "database_subnet_group" {
    name       = "db_securety_group"
    subnet_ids = [var.secure_subnet_az1_id, var.secure_subnet_az2_id]
    description  = "rds in secure subnet"

  tags   = {
    Name = "db-secure-subnets"
  }
}

# create the rds instance
resource "aws_db_instance" "db_instance" {
  engine                  = "mysql"
  engine_version          = "8.0.31"
  multi_az                = false
  identifier              = "petclinic"
  username                = "petclinic"
  password                = "petclinic"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  publicly_accessible     = true
  db_subnet_group_name    = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.database_security_group.id]
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  db_name                 = "petclinic"
  skip_final_snapshot     = true
}
