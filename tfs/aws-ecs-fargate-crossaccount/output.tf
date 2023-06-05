output "ecs-cluster" {
  value = aws_ecs_cluster.cluster
}

output "ecs-cluster-name" {
  value = aws_ecs_cluster.cluster.name
}
