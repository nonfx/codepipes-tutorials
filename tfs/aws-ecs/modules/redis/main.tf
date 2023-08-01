locals {
  extract_resource_name = lower("${var.common_name_prefix}-${var.environment}")
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "${local.extract_resource_name}-redis-sg"
  subnet_ids = var.subnet_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "${local.extract_resource_name}-redis-cluster"
  engine               = "redis"
  engine_version       = var.engine_version
  node_type            = var.instance_type
  num_cache_nodes      = var.num_instances
  parameter_group_name = "default.redis${var.engine_version}"
  port                 = 6379
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = ["${var.security_group}"]
}

# user.tf
resource "aws_elasticache_user" "redis_user" {
  user_id      = var.user_id
  user_name    = var.user_name
  engine       = "REDIS"
  access_string = "on ~* +@all"
  passwords = [random_password.redis_user_password.result]
}

resource "random_password" "redis_user_password" {
  length           = var.password_length
  special          = var.password_special
  override_special = var.password_override_special
}




