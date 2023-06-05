
output "ecs-cluster-name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.nginx_task.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.nginx_lb.dns_name
}
