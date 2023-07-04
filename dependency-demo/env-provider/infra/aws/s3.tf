resource "aws_s3_bucket" "website_bucket" {
  bucket = "app-runner-${random_string.random.result}"
  force_destroy = true
}

resource "aws_s3_bucket_object" "object" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "test.gif"
  source       = "${path.module}/test.gif"
}
