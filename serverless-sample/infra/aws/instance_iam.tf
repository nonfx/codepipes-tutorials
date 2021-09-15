resource "random_string" "instance_role" {
  length           = 4
  special          = false
  upper            = false
  lower            = true
}

resource "random_string" "instance_policy" {
  length           = 4
  special          = false
  upper            = false
  lower            = true
}

resource "aws_iam_role" "instance_role" {
  name = "app-runner-instance-role-${random_string.instance_role.id}"
  assume_role_policy = <<POLICY
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "tasks.apprunner.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
POLICY
}

resource "aws_iam_policy" "instance_policy" {
  name = "app-runner-instance-policy-${random_string.instance_policy.id}"
  description = "A policy with s3 access"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:*",
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_policy_attachment" "instance-attach" {
  name       = "instance-attachment"
  roles      = ["${aws_iam_role.instance_role.name}"]
  policy_arn = "${aws_iam_policy.instance_policy.arn}"
}
