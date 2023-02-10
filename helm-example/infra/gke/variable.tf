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

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes are located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters"
  type        = list
  default     = ["us-central1-c"]
}
