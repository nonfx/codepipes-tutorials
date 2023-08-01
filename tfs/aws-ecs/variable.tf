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


variable "fargate_platform_version" {
  description = "Fargate platform version"
  type        = string
  default     = "1.4.0"
}



variable "cluster_ipv4_cidr" {
  description = "The IP address range of the ecs cluster. Default is an automatically assigned CIDR."
  default = "10.0.0.0/16"
  type    = string
}

variable "enable_db_deletion_protection" {
  description = "Enable RDS database deletion protection when creating the instance"
  type        = bool
  default     = false
}


variable "app_name" {
  description = "application name"
  type        = string
  default     = "transact"
}