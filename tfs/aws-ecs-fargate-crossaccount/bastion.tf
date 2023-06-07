locals {
  extract_resource_name = "codepipes"
}

#Get Latest Amazon Linux AMI
data "aws_ami" "amazon-2" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "bastion-iam-role" {
  name = "${local.extract_resource_name}-bastion-iam-role"

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "bastion-iam-instance-profile" {
  name = "${local.extract_resource_name}-bastion-iam-instance-profile"
  role = aws_iam_role.bastion-iam-role.name
}

resource "aws_instance" "bastion" {
  ami                  = data.aws_ami.amazon-2.id
  instance_type        = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.bastion-iam-instance-profile.name
  subnet_id            = data.aws_subnet.existing_subnet.id
  associate_public_ip_address = false

  vpc_security_group_ids = [
    aws_security_group.nginx_sg.id
  ]

  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  user_data = <<-EOL
  #!/bin/bash -xe
  sudo yum install socat -y
  EOL
}