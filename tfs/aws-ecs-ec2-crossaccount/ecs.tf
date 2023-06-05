
# Reference an existing VPC by its ID
data "aws_vpc" "existing_vpc" {
  id = "vpc-0789949926e072698"  # Update with your VPC ID
}

# Reference an existing subnet by its ID
data "aws_subnet" "existing_subnet" {
  id = "subnet-0df3f6810ecfcf4fc"  # Update with your subnet ID
}

# Create an ECS cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"  # Update with your desired cluster name
}

# Create a security group for EC2 instances
resource "aws_security_group" "ecs_instance_sg" {
  name        = "ecs-instance-sg"
  description = "Security group for ECS instances"
  vpc_id      = data.aws_vpc.existing_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Update with your desired source IP range for SSH access
  }

  # Add any additional ingress rules as needed

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch configuration for EC2 instances
resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix          = "ecs-launch-"
  image_id             = "ami-0123456789abcdef"  # Update with your desired AMI ID
  instance_type        = "t2.micro"  # Update with your desired instance type
  security_groups      = [aws_security_group.ecs_instance_sg.id]
  iam_instance_profile = "ecs-instance-profile"  # Update with your desired IAM instance profile name
  user_data            = <<-EOF
                          #!/bin/bash
                          echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
                          EOF
}

# Autoscaling group for EC2 instances
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                      = "ecs-autoscaling-group"
  min_size                  = 2  # Update with your desired minimum number of instances
  max_size                  = 5  # Update with your desired maximum number of instances
  desired_capacity          = 2  # Update with your desired initial number of instances
  launch_configuration      = aws_launch_configuration.ecs_launch_configuration.name
  vpc_zone_identifier       = [data.aws_subnet.existing_subnet.id]
  target_group_arns         = []  # Update with your desired target group ARNs if using ALB/NLB
  health_check_type         = "EC2"
  termination_policies      = ["Default"]
}

# Output the ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
