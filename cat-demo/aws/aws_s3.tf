resource "aws_s3_bucket" "website_bucket" {
  bucket = "hello-vang-${random_string.random.result}-${replace(lower(var.what_to_say)," ","-")}"
  acl    = "public-read"

  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "Public-Access",
  "Statement": [
    {
      "Sid": "Allow-Public-Access-To-Bucket",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.website_bucket.bucket}/*"
      ]
    }
  ]
}
POLICY
}

resource "local_file" "index_html_aws" {
    content     = templatefile("${path.module}/index.html.tmpl", {orgname = var.orgname, what_to_say = replace(var.what_to_say, " ", "%20")})
    filename = "${path.module}/index.html"
}

resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.module}/index.html"
  content_type = "text/html"
}
