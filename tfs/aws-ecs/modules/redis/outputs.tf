output "redis_address" {
  description = "The address of the Redis cluster"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].address
}

output "redis_port" {
  description = "The port of the Redis cluster"
  value       = aws_elasticache_cluster.redis.cache_nodes[0].port
}

#User Output
output "elasticache_user_id" {
  description = "The user ID of the ElastiCache user"
  value       = aws_elasticache_user.redis_user.user_id
}

output "elasticache_user_name" {
  description = "The user name of the ElastiCache user"
  value       = aws_elasticache_user.redis_user.user_name
}

output "elasticache_user_password" {
  description = "The password of the ElastiCache user"
  value       = random_password.redis_user_password.result
  sensitive   = true
}