# output "firewall-endpoint-id-a" {
#   value = module.network_firewall.firewall-endpoint-id-a
# }

# output "firewall-endpoint-id-b" {
#   value = [for x in module.network_firewall.firewall-endpoint-id-a: x.attachment if x.availability_zone == "ap-south-1a"][0][0].endpoint_id
# }
#General Output
output "region" {
  value = data.aws_region.current.name
}


#ECR Output
output "banking_repository_url" {
  value =  module.ecr["banking"].ecr_repository_url
}

#ECS Output
output "ecs_cluster" {
    value = module.ecs.ecs-cluster-name
}

output "ecs_service" {
    value = {
      for key, ecs_task in module.ecs_task : key => ecs_task.ecs-service-name
    }
}

output "ecs_task_definition" {
    value = {
      for key, ecs_task in module.ecs_task : key => ecs_task.ecs-service-name
    }
}

output "banking_ecs_service" {
  value = module.ecs_task["banking"].ecs-service-name
}

output "banking_task_definition" {
  value = module.ecs_task["banking"].task-definition
}

output "ecs_role_arn" {
  value = module.ecs.ecs_role_arn
}

#DB Output
output "postgres_db_password" {
    value = module.database_postgres.db_password
    sensitive = true
}

output "postgres_db_adress" {
    value = module.database_postgres.db_adress
}

output "postgres_db_endpoint" {
    value = module.database_postgres.db_endpoint
}

output "postgres_connection_string" {
  value = "postgres://postgres:${module.database_postgres.db_password}@${module.database_postgres.db_endpoint}/postgres"
  sensitive = true
}


