data "aws_vpc" "existing_vpc" {
  id = "vpc-0789949926e072698" 
}

data "aws_subnet" "existing_subnet" {
  id = "subnet-0df3f6810ecfcf4fc" 
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster-fargate" 
}


resource "aws_ecs_cluster_capacity_providers" "cluster-capacity-provider" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]
}

