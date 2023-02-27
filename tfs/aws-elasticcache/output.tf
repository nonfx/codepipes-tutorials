output "address" {
  value = aws_elasticache_cluster.redis_version_non_compliant_3.cache_nodes[0].address
}
output "port" {
  value = aws_elasticache_cluster.redis_version_non_compliant_3.cache_nodes[0].port
}
