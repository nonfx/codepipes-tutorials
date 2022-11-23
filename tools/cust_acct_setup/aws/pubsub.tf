resource "aws_kms_key" "cp_pipeline_key" {
  tags = {
    CreatedBy = var.key_name
  }
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Enable IAM User Permissions",
        "Effect" : "Allow",
        "Action" : "kms:*",
        "Resource" : "*",
        "Principal" : {
          "AWS" : "arn:aws:iam::${local.account_id}:root"
        }
      },
      {
        "Sid" : "Enable CloudWatch Permissions",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        },
        "Action" : [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_alias" "cp_pipeline_key_alias" {
  name          = join("/", ["alias", var.key_name])
  target_key_id = aws_kms_key.cp_pipeline_key.key_id
}

resource "aws_sns_topic" "cp-codebuild-topic" {
  name              = var.code_build_topic_name
  kms_master_key_id = aws_kms_key.cp_pipeline_key.key_id
}

resource "aws_sns_topic_policy" "cp-codebuild-topic-policy" {
  arn = aws_sns_topic.cp-codebuild-topic.arn
  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "Allow_Publish_Events",
        "Effect" : "Allow",
        "Action" : "sns:Publish",
        "Principal" : {
          "Service" : "events.amazonaws.com"
        }
        "Resource" : aws_sns_topic.cp-codebuild-topic.arn
      },
    ]
  })
}

resource "aws_sqs_queue" "cp-sqs-queue" {
  name                       = var.code_build_queue_name
  message_retention_seconds  = var.sqs_queue_retention_period
  receive_wait_time_seconds  = var.sqs_queue_receive_wait_time
  visibility_timeout_seconds = 120
  sqs_managed_sse_enabled    = true
}

resource "aws_sqs_queue_policy" "cp-sqs-queue-policy" {
  queue_url = aws_sqs_queue.cp-sqs-queue.id

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "sns.amazonaws.com"
        },
        "Action" : "sqs:SendMessage",
        "Resource" : "${aws_sqs_queue.cp-sqs-queue.arn}",
        "Condition" : {
          "ArnEquals" : {
            "aws:SourceArn" : "${aws_sns_topic.cp-codebuild-topic.arn}"
          }
        }
      }
    ]
  })
}

resource "aws_sns_topic_subscription" "cp-sns-sqs-subscription" {
  topic_arn = aws_sns_topic.cp-codebuild-topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.cp-sqs-queue.arn
}

resource "aws_cloudwatch_event_rule" "cp-eventbridge-rule" {
  name        = "codepipes-code-build-state-change"
  description = "CodeBuild state-change events for CodePipes"

  event_pattern = <<EOF
{
  "detail": {
    "build-status": ["IN_PROGRESS", "SUCCEEDED", "FAILED", "STOPPED"]
  },
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "source": ["aws.codebuild"]
}
EOF
}

resource "aws_cloudwatch_event_target" "cp-eventbridge-target" {
  rule = aws_cloudwatch_event_rule.cp-eventbridge-rule.name
  arn  = aws_sns_topic.cp-codebuild-topic.arn
}
