locals {
  extract_resource_name  = "${var.common_name_prefix}-${var.environment}-${var.number}"
}


resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_flow_log" "vpc-flow-log" {
  iam_role_arn    = aws_iam_role.vpc-flow-log-iam-role.arn
  log_destination = aws_cloudwatch_log_group.vpc-flow-log-group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-flow-logs")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

}

resource "aws_cloudwatch_log_group" "vpc-flow-log-group" {
  name = "${local.extract_resource_name}vpc-flow-log-group"
  retention_in_days =  365

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-flow-log-group")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_iam_role" "vpc-flow-log-iam-role" {
  name = "${local.extract_resource_name}-vpc-flow-log-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = merge(
    {
      "Name" = format("%s", "${local.extract_resource_name}-vpc-flow-log-iam-role")
    },
    {
      environment = var.environment
    },
    var.tags,
  )
}

resource "aws_iam_role_policy" "vpc-flow-log-policy" {
  name = "${local.extract_resource_name}-vpc-flow-log-policy"
  role = aws_iam_role.vpc-flow-log-iam-role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}