locals {
  extract_resource_name  = "test-fargate"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${local.extract_resource_name}-ecs"

}

resource "aws_ecs_cluster_capacity_providers" "cluster-capacity-provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]
}
