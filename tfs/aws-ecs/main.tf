provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}