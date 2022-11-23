locals {
  account_id = data.aws_caller_identity.current.account_id
}
data "aws_caller_identity" "current" {}

resource "aws_iam_user" "cp_user" {
  count = var.create_iamuser ? 1 : 0
  name  = var.username
}

resource "aws_iam_access_key" "cp_user_access" {
  count = var.create_iamuser ? 1 : 0
  user  = aws_iam_user.cp_user[0].name
}

resource "aws_iam_role" "cp_rolearn" {
  count = var.create_rolearn ? 1 : 0
  name  = var.rolename

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = "arn:aws:iam::${var.codepipes_aws_account}:${var.codepipes_aws_account_user}"
        }
        Condition = {
          "StringEquals" : {
            "sts:ExternalId" : "${var.codepipes_org_id}"
          }
        }
      },
    ]
  })
}
