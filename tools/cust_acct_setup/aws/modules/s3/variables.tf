variable "bucket_name" {
  description = "The name of S3 bucket to create"
  type        = string
}

variable "add_logging_policy" {
    description = "Whether to add the logging policy to the bucket"
    type = bool
}
