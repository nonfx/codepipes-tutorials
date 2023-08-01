#Common Variables
variable "common_name_prefix" {
  description = "The common name prefix for resources"
  type        = string
}

variable "environment" {
  description = "The environment name (e.g., prod, staging, dev)"
  type        = string
}

variable "app" {
  description = "The application name"
  type        = string
}

#Target Group Variables
variable "vpc-id" {
  description = "The VPC ID where the resources will be created"
  type        = string
}

variable "healthCheck" {
  description = "Healthcheck for target group"
  type = string
  default = null
}