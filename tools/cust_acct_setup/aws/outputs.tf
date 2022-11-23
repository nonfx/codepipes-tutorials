output "codepipes_user_arn" {
  value = var.create_iamuser ? aws_iam_user.cp_user[0].arn : null
}

output "codepipes_access_key" {
  value = var.create_iamuser ? aws_iam_access_key.cp_user_access[0].id : null
}

output "codepipes_secret_key" {
  value     = var.create_iamuser ? aws_iam_access_key.cp_user_access[0].secret : null
  sensitive = true
}

output "codepipes_role_arn" {
  value = var.create_rolearn ? aws_iam_role.cp_rolearn[0].arn : null
}

output "codepipes_region" {
  value = var.region
}

output "codepipes_artifact_bucket" {
  value = module.cp_artifact_bucket.secure_bucket.arn
}

output "codepipes_code_build_topic" {
  # SNS topic ARN
  value = aws_sns_topic.cp-codebuild-topic.arn
}

output "codepipes_code_build_listener" {
  # SQS queue URL
  value = aws_sqs_queue.cp-sqs-queue.id
}

output "codepipes_kms_key" {
  value = aws_kms_key.cp_pipeline_key.arn
}
