locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

resource "aws_ecs_cluster" "cluster" {
  name = "${local.extract_resource_name}-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-ecs")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_ecs_cluster_capacity_providers" "cluster-capacity-provider" {
  cluster_name = aws_ecs_cluster.cluster.name

  capacity_providers = ["FARGATE"]
}

resource "aws_iam_role" "ecs-iam-role" {
  name = "ecs-iam-role-v2"

  managed_policy_arns = ["arn:aws:iam::aws:policy/SecretsManagerReadWrite", "arn:aws:iam::aws:policy/AmazonS3FullAccess", "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy", "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess","arn:aws:iam::aws:policy/CloudWatchFullAccess"]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
              "Service": "ecs-tasks.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
      }
  ]
}
EOF

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-ecs-iam-role")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}
