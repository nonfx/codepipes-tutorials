
# General variables 
variable "environment" {
  description = "The name for identifying the type of environment"
  type        = string
}

variable "common_name_prefix" {
  description = "The prefix used to name all resources created."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "Any tags that should be present on the Virtual Network resources"
  default     = {}
}

#Redis variable
variable "region" {
  description = "The AWS region"
  default     = "ap-south-1"
}

variable "vpc_id" {
  description = "The VPC ID where the Redis cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs for the Redis cluster"
  type        = list(string)
}

variable "engine_version" {
  description = "The Redis engine version"
  type        = string
  default     = "6.x"
}

variable "instance_type" {
  description = "The instance type for the Redis cluster nodes"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_instances" {
  description = "The number of instances in the Redis cluster"
  type        = number
  default     = 1
}

variable "security_group" {
    description = "Security Group for Redis"
    type        = string
}

#Redis user variables
variable "user_id" {
  description = "The user ID for the ElastiCache user"
  type        = string
}

variable "user_name" {
  description = "The user name for the ElastiCache user"
  type        = string
}

variable "password_length" {
  description = "The length of the generated password"
  type        = number
  default     = 16
}

variable "password_special" {
  description = "Include special characters in the generated password"
  type        = bool
  default     = false
}

variable "password_override_special" {
  description = "List of special characters to use for the generated password"
  type        = string
  default     = "_%+=.,:;@[]!"
}