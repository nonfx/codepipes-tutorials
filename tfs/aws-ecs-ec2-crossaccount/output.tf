# Output the ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
