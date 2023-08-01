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




