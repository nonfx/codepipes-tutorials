variable "GOOGLE_PROJECT" {
  description = "The ID of the project to create the bucket in."
  type        = string
  default = "pranay-test-dev"
}

variable "GOOGLE_VPC_CONNECTOR_NAME" {
  description = "Name of VPC access connector"
  type        = string
  default     = "vpc-con"
}

variable "IP_CIDR_RANGE" {
  description = "Network cidr range"
  type        = string
  default     = "10.8.0.0/28"
}

provider "random" {}

resource "random_string" "random" {
  length    = 5
  special   = false
  min_lower = 5
}

resource "random_integer" "subnet" {
  min = 1
  max = 256
}

resource "random_integer" "mask" {
  min = 24
  max = 30
}
