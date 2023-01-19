resource "aws_iam_policy" "cp_policy" {
  name        = var.iam_pipeline_policy_name
  path        = "/"
  description = "Policy with permissions required to use Code Pipes"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObjectVersion",
          "s3:DeleteObject",
          "s3:PutReplicationConfiguration"
        ],
        "Resource" : "arn:aws:s3:::*/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:ListBucketVersions",
          "s3:CreateBucket",
          "s3:ListBucket",
          "s3:DeleteBucket",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:PutBucketVersioning",
          "s3:CreateReplicationRole",
          "s3:PutBucketLogging",
          "s3:PutBucketReplication",
        ],
        "Resource" : "arn:aws:s3:::*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "codebuild:BatchGetBuilds",
          "codebuild:BatchGetProjects",
          "codebuild:CreateProject",
          "codebuild:DeleteProject",
          "codebuild:ListBuildBatches",
          "codebuild:ListBuilds",
          "codebuild:ListBuildsForProject",
          "codebuild:ListProjects",
          "codebuild:RetryBuild",
          "codebuild:StartBuild",
          "codebuild:StopBuild",
          "codebuild:UpdateProject",
          "events:PutRule",
          "events:PutTargets",
          "iam:CreatePolicy",
          "iam:CreateRole",
          "iam:GetPolicy",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
          "iam:ListPolicyVersions",
          "iam:ListEntitiesForPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRolePolicies",
          "iam:PassRole",
          "kms:CreateKey",
          "kms:CreateAlias",
          "kms:DescribeKey",
          "kms:GetKeyPolicy",
          "kms:PutKeyPolicy",
          "kms:TagResource",
          "iam:DeletePolicy",
          "iam:DeleteRole",
          "iam:AttachRolePolicy",
          "iam:DetachRolePolicy",
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret",
          "secretsmanager:DescribeSecret",
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecretVersionIds",
          "secretsmanager:ListSecrets",
          "secretsmanager:PutSecretValue",
          "secretsmanager:UpdateSecret",
          "sns:ConfirmSubscription",
          "sns:CreateTopic",
          "sns:DeletePlatformApplication",
          "sns:DeleteTopic",
          "sns:GetSubscriptionAttributes",
          "sns:GetTopicAttributes",
          "sns:ListSubscriptions",
          "sns:ListSubscriptionsByTopic",
          "sns:ListTopics",
          "sns:Publish",
          "sns:SetSubscriptionAttributes",
          "sns:SetTopicAttributes",
          "sns:Subscribe",
          "sns:Unsubscribe",
          "sqs:ChangeMessageVisibility",
          "sqs:CreateQueue",
          "sqs:DeleteMessage",
          "sqs:DeleteQueue",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ListQueueTags",
          "sqs:ListQueues",
          "sqs:PurgeQueue",
          "sqs:ReceiveMessage",
          "sqs:SendMessage",
          "sqs:SetQueueAttributes"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "cp-attach-user" {
  count      = var.create_iamuser ? 1 : 0
  user       = aws_iam_user.cp_user[0].name
  policy_arn = aws_iam_policy.cp_policy.arn
}

resource "aws_iam_role_policy_attachment" "cp-attach-role" {
  count      = var.create_rolearn ? 1 : 0
  role       = aws_iam_role.cp_rolearn[0].name
  policy_arn = aws_iam_policy.cp_policy.arn
}

resource "aws_iam_policy" "cp-codebuild-policy" {
  name = var.iam_codebuild_policy_name
  path = "/"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetRandomPassword",
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "s3:*",
          "sts:*",
          "logs:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "cp-codebuild-role" {
  name = var.iam_codebuild_role_name

  assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "codebuild.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

resource "aws_iam_role_policy_attachment" "cp-attach-codebuild" {
  role       = aws_iam_role.cp-codebuild-role.name
  policy_arn = aws_iam_policy.cp-codebuild-policy.arn
}
