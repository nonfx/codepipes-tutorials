locals {
  extract_resource_name = lower("${var.common_name_prefix}-${var.environment}")
}


resource "aws_db_subnet_group" "db-subnet-group" {
  name       = "${local.extract_resource_name}-db-subnet-group"
  subnet_ids = [var.subnet-db-a-id, var.subnet-db-b-id]

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-db-subnet-group")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "random_password" "password_postgres" {
  length  = 16
  special = false
}

resource "aws_db_instance" "db" {
  identifier              = "${local.extract_resource_name}-db"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "postgres"
  username                = "postgres"
  password                = random_password.password_postgres.result
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-group.name
  vpc_security_group_ids  = [var.db-sg-id]
  storage_encrypted       = true
  db_name                 = "postgres"
  backup_retention_period = 7
  backup_window           = "20:00-21:00"
  maintenance_window      = "Sat:23:00-Sun:03:00"
  #   multi_az = true
  #   publicly_accessible    = true
  skip_final_snapshot = true

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-db")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}


