output "redis_hostname" {
  value = aws_elasticache_cluster.demo-ec.cache_nodes.0.address
}

output "redis_port" {
  value = tostring(aws_elasticache_cluster.demo-ec.cache_nodes.0.port)
}

output "redis_endpoint" {
  value = join(":", tolist([aws_elasticache_cluster.demo-ec.cache_nodes.0.address, aws_elasticache_cluster.demo-ec.cache_nodes.0.port]))
}

output "ecr_role" {
  value = aws_iam_role.ecr_role.arn
}

output "vpc_connector" {
  value = aws_apprunner_vpc_connector.demo-vpc-conn.arn
}
