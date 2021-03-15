output "aws_url" {
  value = aws_s3_bucket.website_bucket.website_endpoint
}
