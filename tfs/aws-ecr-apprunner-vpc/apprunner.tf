
# VPC Connector for AppRunner
resource "aws_apprunner_vpc_connector" "demo-vpc-conn" {
  vpc_connector_name = local.name
  subnets            = module.vpc.database_subnets
  security_groups    = [module.security_group_vpc_connector.security_group_id]
}

# ECR role for AppRunner
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

# Instance Role for AppRunner
resource "aws_iam_role" "instance_role" {
  name               = "app-runner-instance-role-${random_string.random.id}"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "tasks.apprunner.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
POLICY
}

resource "aws_iam_policy" "instance_policy" {
  name        = "app-runner-instance-policy-${random_string.random.id}"
  description = "A policy with rds access"
  policy      = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [ "rds-db:connect" ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "elasticache:*",
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "instance-attach" {
  name       = "instance-attachment"
  roles      = ["${aws_iam_role.instance_role.name}"]
  policy_arn = aws_iam_policy.instance_policy.arn
}

module "security_group_vpc_connector" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name   = "demo-vpc-${random_string.random.id}"
  vpc_id = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      rule        = "postgresql-tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = local.tags
}