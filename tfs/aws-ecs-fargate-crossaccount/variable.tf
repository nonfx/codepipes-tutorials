variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}
variable "ecs_cluster_name" {
  description = "Name of the ecs cluster"
  type        = string
  default = "my-cluster-default"
}

variable "container_image" {
  description = "container image reference"
  type = string
  default = "nginx:latest"
}
variable "role_arn" {
  description = "ARN of the IAM role in the target account"
  type        = string
}

variable "fargate_platform_version" {
  description = "Fargate platform version"
  type        = string
  default     = "1.4.0"
}

variable "external_id" {
  description = "Optional external ID, if required by the role"
  type        = string
}
