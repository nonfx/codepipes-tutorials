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

#Route Table Variables
variable "vpc-id" {}

variable "subnet-firewall-a-id" {}
variable "subnet-firewall-b-id" {}

variable "subnet-internet-a-id" {}
variable "subnet-internet-b-id" {}

variable "subnet-web-a-id" {}
variable "subnet-web-b-id" {}

variable "subnet-app-a-id" {}
variable "subnet-app-b-id" {}

variable "firewall-a-endpoint-id" {}
variable "firewall-b-endpoint-id" {}