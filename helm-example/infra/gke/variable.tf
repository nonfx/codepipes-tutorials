provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}

variable "GOOGLE_PROJECT" {
  description = "The ID of the project to create the bucket in."
  type        = string
  default     = "pranay-test-dev"
}

variable "location" {
  description = "location"
  type        = string
  default     = "us-central1-a"
}

variable "CLUSTER_NAME" {
  description = "cluster name"
  type        = string
  default     = "test-cluster"
}