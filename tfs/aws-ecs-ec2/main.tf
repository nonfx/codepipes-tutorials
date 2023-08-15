provider "aws" {
  region = "us-east-1" # Update with your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-security-group"
  description = "ECS security group"
  
  vpc_id = aws_vpc.my_vpc.id
  
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc.cidr_block]
  }
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_launch_configuration" "my_launch_config" {
  name_prefix   = "my-launch-config-"
  image_id      = "ami-12345678"  # Replace with your desired EC2 instance image
  instance_type = "t2.micro"      # Replace with your desired instance type
}

resource "aws_autoscaling_group" "my_asg" {
  name                 = "my-autoscaling-group"
  launch_configuration = aws_launch_configuration.my_launch_config.name
  min_size             = 2
  max_size             = 5
  desired_capacity     = 2

  vpc_zone_identifier = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id]
}
