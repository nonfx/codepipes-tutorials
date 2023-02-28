provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {}

provider "random" {}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
  lower   = true
}

# Elasticache Cluster
resource "aws_elasticache_cluster" "demo-ec" {
  cluster_id           = "redis-${random_string.random.id}"
  engine               = "redis"
  node_type            = var.redis_node_type
  num_cache_nodes      = 1
  parameter_group_name = var.redis_param_group
  engine_version       = var.redis_version
  port                 = var.redis_port
  apply_immediately    = true
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
  security_group_ids   = [aws_security_group.redissg.id]
}

# VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "vpc-${random_string.random.id}"
  }
}

resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "vpc-subnet-${random_string.random.id}"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "redis-subnet-${random_string.random.id}"
  subnet_ids = [aws_subnet.demo-subnet.id]
}

resource "aws_security_group" "redissg" {
  name   = "redis-sg-${random_string.random.id}"
  vpc_id = aws_vpc.demo-vpc.id


  # Allowing traffic only for Postgres and that too from same VPC only.
  ingress {
    description = "Redis"
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }


  # Allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg-${random_string.random.id}"
  }
}

resource "aws_apprunner_vpc_connector" "demo-vpc-conn" {
  vpc_connector_name = "vpc-conn-${random_string.random.id}"
  subnets            = [aws_subnet.demo-subnet.id]
  security_groups    = [aws_security_group.redissg.id]
}


# ECR role for App-runner
resource "aws_iam_role" "ecr_role" {
  name               = "app-runner-ecr-role-${random_string.random.id}"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "build.apprunner.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
POLICY
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "app-runner-ecr-policy-${random_string.random.id}"
  description = "A policy with  ECR access"
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "ecr-attach" {
  name       = "ecr-attachment"
  roles      = ["${aws_iam_role.ecr_role.name}"]
  policy_arn = aws_iam_policy.ecr_policy.arn
}
