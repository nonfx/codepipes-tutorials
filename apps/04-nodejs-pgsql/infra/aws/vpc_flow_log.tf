resource "aws_flow_log" "demo-vpc" {
  iam_role_arn    = aws_iam_role.flow-log.arn
  log_destination = aws_cloudwatch_log_group.demo-vpc.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.demo-vpc.id
}

resource "aws_cloudwatch_log_group" "demo-vpc" {
  name = "demo-vpc"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "flow-log" {
  name               = "flow_log_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "flow-log" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "flow-log" {
  name   = "flow_log_policy"
  role   = aws_iam_role.flow-log.id
  policy = data.aws_iam_policy_document.flow-log.json
}