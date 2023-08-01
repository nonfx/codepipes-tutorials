locals {
  extract_resource_name = lower("${var.common_name_prefix}-${var.environment}")
}

resource "random_password" "password_doc" {
  length           = 16
  special          = false
}

resource "aws_docdb_subnet_group" "documentdb_subnet_group" {
  name       = "${local.extract_resource_name}-documentdb-subnet-group"
  subnet_ids = [var.subnet-db-a-id, var.subnet-db-b-id]
}

resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "${local.extract_resource_name}-docdb-cluster"
  engine                  = "docdb"
  master_username         = "carefiadmin"
  master_password         = random_password.password_doc.result
  db_subnet_group_name    = aws_docdb_subnet_group.documentdb_subnet_group.name
  backup_retention_period = 5
  preferred_backup_window = "18:00-20:00"
  preferred_maintenance_window = "sat:03:00-sat:05:00"
  skip_final_snapshot     = true
  vpc_security_group_ids  = [var.db-sg-id]
  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-docdb")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.number
  identifier         = "${local.extract_resource_name}-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb.id
  instance_class     = "db.t4g.medium"
  apply_immediately  = true
}

resource "aws_docdb_subnet_group" "docdb" {
  name       = "${local.extract_resource_name}-docdb-subnet-group"
  subnet_ids = [var.subnet-db-a-id, var.subnet-db-b-id]

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-docdb-subnet-group")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}