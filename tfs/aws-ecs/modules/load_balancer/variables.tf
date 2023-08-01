# General variables 
variable "common_name_prefix" {
  description = "A common prefix for naming resources"
}

variable "environment" {
  description = "The environment for the resources (e.g. dev, prod)"
}

variable "number" {
  description = "A unique identifier for the resources"
}

variable "tags" {
  description = "A map of tags to be added to resources"
  type        = map(string)
  default     = {}
}

#Load Balancer Variables
variable "subnet-internet-a-id" {
  description = "The ID of the first public subnet where the Load Balancer will be created"
}

variable "subnet-internet-b-id" {
  description = "The ID of the second public subnet where the Load Balancer will be created"
}

variable "lb-sg-id" {
  description = "The ID of the security group to be associated with the Load Balancer"
}

variable "size_restrictions_body_override_action" {
  type        = string
  description = "Override action for the SizeRestrictions_BODY rule"
  default     = "allow"
}
