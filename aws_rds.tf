provider "aws" {
  region     = "ap-south-1"
  profile    = "terra_use"
}

resource "aws_security_group" "allow_sql" {

  name        = "allow_sql"
  description = "Allow sql inbound traffic"
  vpc_id      = "vpc-aef7eac6"

  ingress {
    description = "sql from VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_sql"
  }
}

resource "aws_db_instance" "mysql" {
  identifier = "database-sql"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.30"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "gaurav"
  password             = "gauravkhore"
  parameter_group_name = "default.mysql5.7"
  iam_database_authentication_enabled = true
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [ "${aws_security_group.allow_sql.id}"]
}

output "ip" {
value = "${aws_db_instance.mysql.address}"
}