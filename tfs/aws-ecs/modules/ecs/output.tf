output "ecs-cluster" {
  value = aws_ecs_cluster.cluster
}

output "ecs-cluster-name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}

output "ecs_role_arn" {
  value = aws_iam_role.ecs-iam-role.arn
}

