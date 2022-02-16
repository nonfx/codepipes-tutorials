resource "aws_s3_bucket" "alb" {
  count = var.alb_access_bucket_enabled ? 1 : 0
  bucket = "alb-access-bucket-${random_string.cluster.id}"
  force_destroy = true
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket_policy" "allow_access" {
  count = var.alb_access_bucket_enabled ? 1 : 0
  bucket = aws_s3_bucket.alb[count.index].id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${data.aws_elb_service_account.main.id}:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb[count.index].id}/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb[count.index].id}/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${aws_s3_bucket.alb[count.index].id}"
    }
  ]
}
POLICY
}

