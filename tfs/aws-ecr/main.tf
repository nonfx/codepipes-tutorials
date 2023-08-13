provider "aws" {
  region = var.region
}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}


resource "aws_ecr_repository" "demo-repository" {
  name                 = "demo-repo-${random_string.random.id}"
  image_tag_mutability = "IMMUTABLE"
}
