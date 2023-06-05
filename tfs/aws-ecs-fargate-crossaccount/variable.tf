variable "region" {
  description = "region"
  type        = string
  default     = "us-east-1"
}

variable "role_arn" {
  description = "ARN of the IAM role in the target account"
  type        = string
}

variable "external_id" {
  description = "Optional external ID, if required by the role"
  type        = string
}
