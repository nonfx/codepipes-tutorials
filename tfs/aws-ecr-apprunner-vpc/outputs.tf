output "ecr_role" {
  value       = resource.aws_iam_role.ecr_role.arn
  description = "The ARN for the ECR access role"
}

output "instance_role" {
  value       = resource.aws_iam_role.instance_role.arn
  description = "The ARN for the AppRunner instance access role"
}

output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The id for the VPC"
}

output "vpc_connector" {
  value       = resource.aws_apprunner_vpc_connector.demo-vpc-conn.arn
  description = "The ARN for the VPC Connector to use with AppRunner"
}

output "db_subnet_group_name" {
  value       = module.vpc.database_subnet_group_name
  description = "Subnet group to use for Databases"
}

output "aws_region" {
  value       = data.aws_region.current.name
  description = "AWS region that the resources were provisioned in"
}

output "vpc_endpoint" {
  value       = module.vpc_endpoints.endpoints
  description = "The VPC Endpoint for the RDS"
}