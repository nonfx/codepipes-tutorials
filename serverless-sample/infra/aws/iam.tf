resource "random_string" "role" {
  length           = 4
  special          = false
  upper            = false
  lower            = true
}

resource "random_string" "policy" {
  length           = 4
  special          = false
  upper            = false
  lower            = true
}

resource "aws_iam_role" "app_runner_access_role" {
  name = "test-app-runner-role-${random_string.role.id}"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "apprunner.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
POLICY
}

resource "aws_iam_policy" "policy" {
  name = "test-app-runner-role-${random_string.policy.id}"
  description = "A policy with s3 and ECR access"
  policy = <<POLICY
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
    },
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "app-runner-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.app_runner_access_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}