# General variables 
variable "environment" {
  description = "The name for identifying the type of environment"
  type        = string
}

variable "common_name_prefix" {
  description = "The prefix used to name all resources created."
  type        = string
}

variable "number" {
  description = "The count of the resource"
  default     = 001
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {}
}

variable "apps" {
  description = "Array of apps for which resources needs to be created"
}

#ECS Variables
variable "role_arn" {
    description = "Role ARN for ECS Task and Services"
}

variable "aws-account-id" {}

variable "ecs_cluster" {
  description = "ECS Cluster to create task and service for"
}

variable "security_groups" {
  description = "Security Group for ECS Task and Service"
}

variable "subnets" {
  description = "Subnets for ECS Task and Service"
}

variable "target_group_arn" {
  description = "Target group ARN"
}

variable "site" {
  description = "The host header for the listener rule"
  type        = list(string)
  default     = null
}

variable "ecs_image" {
  description = "The image to use for the ECS Task"
  type = string
  default = "docker/getting-started"
}