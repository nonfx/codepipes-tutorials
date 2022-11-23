module "cp_artifact_bucket" {
  source = "./modules/s3"

  bucket_name        = join("-", [var.bucket_name_prefix, "pipeline-artifacts", var.region, var.account_id])
  add_logging_policy = false
}

module "cp_compliance_bucket" {
  source = "./modules/s3"

  bucket_name        = join("-", [var.bucket_name_prefix, "compliance", var.region, var.account_id])
  add_logging_policy = true
}

# setup access logging
resource "aws_s3_bucket_logging" "cp_bucket_logging_artifact" {
  bucket = module.cp_artifact_bucket.secure_bucket.id

  target_bucket = module.cp_compliance_bucket.secure_bucket.id
  target_prefix = "access_log/"
}
resource "aws_iam_role" "replication" {
  name = join("-", [var.bucket_name_prefix, "replication-role"])

  assume_role_policy = <<POLICY
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "s3.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }
POLICY
}

resource "aws_iam_policy" "replication" {
  name   = join("-", [var.bucket_name_prefix, "replication-policy"])
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "EnableSrcBucketAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetReplicationConfiguration",
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::*"
            ]
        },
        {
            "Sid": "EnableSrcObjectsAccess",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectVersion",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging"
            ],
            "Resource": [
                "arn:aws:s3:::*/*"
            ]
        },
        {
            "Sid": "EnableDestAccess",
            "Effect": "Allow",
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags"
            ],
            "Resource": "${module.cp_compliance_bucket.secure_bucket.arn}/*"
        }   
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}


resource "aws_s3_bucket_replication_configuration" "cp_artifact_bucket_replication" {
  role   = aws_iam_role.replication.arn
  bucket = module.cp_artifact_bucket.secure_bucket.id
  depends_on = [module.cp_artifact_bucket.secure_bucket_versioning, module.cp_compliance_bucket.secure_bucket_versioning]

  rule {
    filter {
      prefix = ""
    }

    status   = "Enabled"
    priority = 1
    destination {
      bucket = module.cp_compliance_bucket.secure_bucket.arn
    }
    delete_marker_replication {
      status = "Disabled"
    }
  }
}
