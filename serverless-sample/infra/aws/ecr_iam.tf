resource "random_string" "ecr_role" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

resource "random_string" "ecr_policy" {
  length  = 4
  special = false
  upper   = false
  lower   = true
}

resource "aws_iam_role" "ecr_role" {
  name               = "app-runner-ecr-role-${random_string.ecr_role.id}"
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
  name        = "app-runner-ecr-policy-${random_string.ecr_policy.id}"
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
