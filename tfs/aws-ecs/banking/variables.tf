variable "aws-account-id" {
  default = "279513215685"
}

variable "aws-acm-certificate" {
  default = "0b0ef27f-bfd7-4a68-841b-449e975d7b6a"
}

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
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}

variable "number" {
  description = "The count of the resource"
  default     = 001
}

variable "apps" {
  description = "Array of apps for which resources needs to be created"
  type = map(object({
    path = list(string)
    site = list(string)
    healthCheck = optional(string)
  }))
}

#VPC Variables
variable "vpc_cidr_block" {
  description = "CIDR Block to be used by VPC"
  default = "10.1.0.0/16"
  type = string
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults to true."  
  default = true
  type = bool
}


#ECR Variables
variable "ecr_image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
  type = string
  default = "MUTABLE"
}

variable "ecr_enable_force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false."
  type = bool
  default = true
}

variable "ecr_enable_scan_on_push" {
  description = " Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type = bool
  default = true
}

variable "ecr_encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256."
  type = string
  default = "KMS"
}

#LB WAF Variables
variable "size_restrictions_body_override_action" {
  type        = string
  description = "Override action for the SizeRestrictions_BODY rule"
  default     = "allow"
}

#ECR Repository
variable "additional_ecr_access_account_id" {
  description = "Another AWS account ID to be granted access to the ECR repository"
  type        = string
  default     = null
}