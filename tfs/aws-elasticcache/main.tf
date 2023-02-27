provider "aws" {
  region = var.region
}

resource "aws_elasticache_cluster" "redis_version_non_compliant_3" {
  cluster_id           = "cluster-example"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.4"
  port                 = 6379
}