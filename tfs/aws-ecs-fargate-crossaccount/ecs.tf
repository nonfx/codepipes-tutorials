data "aws_vpc" "existing_vpc" {
  id = "vpc-04f2d3c201e9a2de2" # Update with your VPC ID
}

# Reference an existing subnet by its ID
data "aws_subnet" "existing_subnet" {
  id = "subnet-0d347ca43bd641372" # Update with your subnet ID
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.ecs_cluster_name
}


resource "aws_ecs_cluster_capacity_providers" "cluster-capacity-provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}

