provider "aws" {
  region  = "us-east-1"
}


# terraform {
#   required_version = ">= 0.12"
# }

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}