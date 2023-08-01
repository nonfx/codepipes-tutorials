
output "ecs-service-name" {
  value = aws_ecs_service.service.name
}


output "task-definition" {
  value = aws_ecs_task_definition.task-definition.family
}

output "service_arn" {
  value = aws_ecs_service.service.id
}