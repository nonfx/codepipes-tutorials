output "aws_url" {
  value = "http://${aws_s3_bucket.website_bucket.website_endpoint}/index.html"
}
