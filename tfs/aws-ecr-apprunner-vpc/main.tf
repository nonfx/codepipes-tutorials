# This is a base environment that includes a VPC, VPC subnet 
# and AppRunner config including ECR role and VPC connector

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

provider "random" {}

locals {
  name             = "demo-${random_string.random.id}"
  vpc_cidr         = "10.0.0.0/16"
  azs              = slice(data.aws_availability_zones.available.names, 0, 2)
  current_identity = data.aws_caller_identity.current.arn

  tags = {
    Name = local.name
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  lower   = true
}
