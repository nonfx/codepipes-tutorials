resource "aws_flow_log" "demo" {
  iam_role_arn     = aws_iam_role.demo.arn
  log_destination  = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type     = "ALL"
  vpc_id           = aws_vpc.demo.id
}

resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name = "vpc_flow_log-${random_string.cluster.id}"
  kms_key_id = element(aws_kms_key.flow_log_key.*.arn,0)
}

resource "aws_kms_key" "flow_log_key" {
  description             = "KMS key for CloudWatch vpc flow logs"
  deletion_window_in_days = 7
  policy = <<EOF
{
  "Version" : "2012-10-17",
  "Id" : "key-default-1",
  "Statement" : [ {
      "Sid" : "Enable IAM User Permissions",
      "Effect" : "Allow",
      "Principal" : {
        "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      },
      "Action" : "kms:*",
      "Resource" : "*"
    },
    {
      "Effect": "Allow",
      "Principal": { "Service": "logs.${var.aws_region}.amazonaws.com" },
      "Action": [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "demo" {
  name = "flow-log-role-${random_string.role.id}"

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
}

resource "aws_iam_policy" "demo" {
  name = "flow-log-role-policy-${random_string.role.id}"

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

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.demo.id
  policy_arn = aws_iam_policy.demo.arn
}
