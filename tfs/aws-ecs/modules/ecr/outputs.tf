#ECR Output
output "ecr_repository_url" {
  value = aws_ecr_repository.main.repository_url
}

output "ecr_registry_id" {
  value = aws_ecr_repository.main.registry_id 
}



