variable "region" {
  description = "The name of the AWS region to use"
  type        = string
}

variable "account_id" {
  description = "The AWS Account number where the resources are to be created"
  type        = string
}
variable "username" {
  description = "The name of the IAM user to create"
  type        = string
  default     = "codepipes-user"
}

variable "rolename" {
  description = "The name of the IAM role to create"
  type        = string
  default     = "codepipes_role"
}

variable "codepipes_org_id" {
  description = "Code Pipes Organization ID to be used during role ARN creation"
  type        = string
  default     = ""
}

variable "create_rolearn" {
  description = "Use AWS Role ARN as Code Pipes credential"
  type        = bool
  default     = false
}

variable "create_iamuser" {
  description = "Use AWS IAM user as Code Pipes credential"
  type        = bool
  default     = true
}

variable "bucket_name_prefix" {
  description = "The prefix to use for names of the S3 buckets to be used for storing Code Pipes pipeline artifacts"
  type        = string
  default     = "codepipes"
}

variable "key_name" {
  description = "The KMS key name to create"
  type        = string
  default     = "codepipes_kms_key"
}

variable "code_build_topic_name" {
  description = "The SNS topic name for Code Build"
  type        = string
  default     = "code-builds"
}

variable "code_build_queue_name" {
  description = "The SQS queue name for Code Build"
  type        = string
  default     = "codepipes-events"
}

variable "sqs_queue_retention_period" {
  description = "The SQS queue message retention period in seconds"
  type        = number
  default     = 172800 # 2 days
}

variable "sqs_queue_receive_wait_time" {
  description = "The SQS queue receive wait time in seconds"
  type        = number
  default     = 20
}

variable "codepipes_aws_account" {
  description = "AWS account used for Role ARN creation"
  type        = string
  default     = "303665096113"
}

variable "codepipes_aws_account_user" {
  description = "AWS IAM user in codepipes_aws_account used by Code Pipes"
  type        = string
  default     = "root"
}
