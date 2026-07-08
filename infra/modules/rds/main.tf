resource "aws_security_group" "rds" {
  name   = "${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnets
}

resource "aws_db_instance" "postgres" {
  identifier = "${var.environment}-postgres"

  engine         = "postgres"
  engine_version = "15"

  instance_class = var.environment == "prod" ? "db.t3.small" : "db.t3.micro"

  allocated_storage = 20

  username = "admin"
  password = "Password123!"

  db_name = "hotel"

  publicly_accessible = false
  skip_final_snapshot = true

  deletion_protection = var.environment == "prod"

  backup_retention_period = var.environment == "prod" ? 7 : 1

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
}