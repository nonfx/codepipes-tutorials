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

# ECS
variable "aws_ami_id" {
  type = string
  default = "ami-0715c1897453cabd1"
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}
