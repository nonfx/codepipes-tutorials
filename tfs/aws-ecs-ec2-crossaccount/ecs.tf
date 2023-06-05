
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
    from_port   = 80
    to_port     = 80
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
  image_id             = var.aws_ami_id
  instance_type        = var.aws_instance_type
  security_groups      = [aws_security_group.ecs_instance_sg.id]
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

# Define your ECS cluster capacity providers
resource "aws_ecs_cluster_capacity_providers" "cluster_capacity_provider" {
  cluster_name        = aws_ecs_cluster.ecs_cluster.name
  capacity_providers  = [aws_autoscaling_group.ecs_autoscaling_group.name]
  default_capacity_provider_strategy {
    capacity_provider = aws_autoscaling_group.ecs_autoscaling_group.name
  }
}

# Define your ECS task definition
resource "aws_ecs_task_definition" "ngnix_task_definition" {
  family                = "ngnix-task"
  container_definitions = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx:latest",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ]
  }
]
DEFINITION
}

# Define your ECS service
resource "aws_ecs_service" "ngnix_service" {
  name            = "ngnix-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ngnix_task_definition.arn
  desired_count   = 1
  launch_type     = "EC2"

  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets         = [data.aws_subnet.existing_subnet.id]
    security_groups = [aws_security_group.ecs_instance_sg.id]
  }
}
