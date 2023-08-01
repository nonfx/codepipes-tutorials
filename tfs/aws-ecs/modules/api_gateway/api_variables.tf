# Define variables
variable "common_name_prefix" {
  type        = string
  description = "The common name prefix to use for all resources"
}

variable "environment" {
  type        = string
  description = "The environment to deploy the resources in"
}

variable "region" {
  type        = string
  description = "The region to deploy the resources in"
}

variable "backend_uri" {
  type        = string
  description = "The URI of the backend servic to point to"
}

variable "api_key_name" {
  description = "Name for the API key."
  default     = "my-api-key"  # Update with your desired name
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  default     = "my-ecs-cluster"  # Update with your ECS cluster name
}

variable "ecs_service_name" {
  description = "Name of the ECS service."
  default     = "my-ecs-service"  # Update with your ECS service name
}

variable "ecs_service_arn" {
  description = "ARN of the ECS Service."
  default     = "arn:aws:ecs:us-east-1:123456789012:cluster/my-ecs-cluster"  # Update with your ECS cluster ARN
}


variable "custom_domain_name" {
  description = "Custom domain name for the API Gateway."
  default     = "api.example.com"  # Update with your custom domain name
}

variable "certificate_arn" {
  description = "ARN of the SSL/TLS certificate for the custom domain."
  default     = "arn:aws:acm:us-east-1:123456789012:certificate/abcdefg"  # Update with your certificate ARN
}

variable "task_definition_arn" {
  description = "ARN of the ECS task definition."
  default     = "arn:aws:ecs:us-east-1:123456789012:task-definition/my-task-def:1"  # Update with your task definition ARN
}

variable "api_gateway_url" {
  description = "API Gateway URL."
  default     = "https://api.example.com"  # Update with your API Gateway URL
}

