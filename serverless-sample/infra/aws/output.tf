output "aws_bucket" {
  value = aws_s3_bucket.website_bucket.bucket
}
output "aws_ecr_role" {
  value = aws_iam_role.ecr_role.arn
}

output "aws_instance_role" {
  value = aws_iam_role.instance_role.arn
}