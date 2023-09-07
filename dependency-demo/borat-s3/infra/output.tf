output "aws_ecr_role" {
  value = aws_iam_role.ecr_role.arn
}

output "aws_instance_role" {
  value = aws_iam_role.instance_role.arn
}

output "aws_region" {
  value = var.aws_region
}