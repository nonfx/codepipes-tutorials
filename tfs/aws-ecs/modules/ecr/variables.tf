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

variable "app" {
  description = "Name of app for which resources needs to be created"
}

#ECR Variables
variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE."
  type = string
  default = "MUTABLE"
}

variable "enable_force_delete" {
  description = "If true, will delete the repository even if it contains images. Defaults to false."
  type = bool
  default = false
}

variable "enable_scan_on_push" {
  description = " Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  type = bool
  default = true
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS. Defaults to AES256."
  type = string
  default = "KMS"
}

variable "additional_ecr_access_account_id" {
  description = "Another AWS account ID to be granted access to the ECR repository"
  type        = string
  default     = null
}
