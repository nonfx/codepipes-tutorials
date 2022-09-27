variable "GOOGLE_PROJECT" {
  description = "The ID of the project to create the bucket in."
  type        = string
}

variable "GOOGLE_VPC_CONNECTOR_NAME" {
  description = "Name of VPC access connector"
  type        = string
  default     = "vpc-con-test"
}

variable "IP_CIDR_RANGE" {
  description = "Network cidr range"
  type        = string
  default     = "10.0.0.0/28"
}