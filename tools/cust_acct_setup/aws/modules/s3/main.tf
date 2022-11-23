resource "aws_s3_bucket" "secure_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_s3_bucket_acl" "secure_bucket_acl" {
  bucket = aws_s3_bucket.secure_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "secure_bucket_versioning" {
  bucket = aws_s3_bucket.secure_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "secure_bucket_encryption" {
  bucket = aws_s3_bucket.secure_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "single_policy" {
  count  = var.add_logging_policy ? 0 : 1
  bucket = aws_s3_bucket.secure_bucket.id
  policy = data.aws_iam_policy_document.ssl_only.json
}

resource "aws_s3_bucket_policy" "with_logging_policy" {
  count  = var.add_logging_policy ? 1 : 0
  bucket = aws_s3_bucket.secure_bucket.id
  policy = data.aws_iam_policy_document.merged_policies.json
}

data "aws_iam_policy_document" "merged_policies" {
  source_policy_documents = [
    data.aws_iam_policy_document.ssl_only.json,
    data.aws_iam_policy_document.logging_access.json
  ]
}

data "aws_iam_policy_document" "logging_access" {
  statement {
    sid = "s3_server_access_logs_policy"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    effect = "Allow"
    resources = [
      "${aws_s3_bucket.secure_bucket.arn}/*",
    ]
  }
}

data "aws_iam_policy_document" "ssl_only" {
  statement {
    sid = "s3_bucket_ssl_requests_only"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
    effect = "Deny"
    resources = [
      aws_s3_bucket.secure_bucket.arn,
      "${aws_s3_bucket.secure_bucket.arn}/*",
    ]
  }
}
