resource "aws_ecs_task_definition" "nginx_task" {
  family = "nginx-task"
  execution_role_arn       = aws_iam_role.ecs-iam-role.arn
  task_role_arn            = aws_iam_role.ecs-iam-role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions = <<DEFINITION
  [
    {
      "name": "nginx-1",
      "image": "${var.container_image}",
      "cpu": 256,
      "memory": 512,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/nginx-task",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "nginx"
        }
      }
    }
  ]
  DEFINITION
}

resource "aws_ecs_service" "nginx_service" {
  name            = "nginx-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  platform_version = var.fargate_platform_version
  network_configuration {
    subnets          = aws_subnet.demo[*].id
    assign_public_ip = false
    security_groups  = [aws_security_group.nginx_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.nginx_tg.arn
    container_name   = "nginx-1"
    container_port   = 80
  }
}

resource "aws_security_group" "nginx_sg" {
  name        = "${var.ecs_cluster_name}-nginx-sg"
  description = "Security group for NGINX"
  vpc_id      = aws_vpc.demo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "nginx_lb" {
  name               = "${random_string.random.id}-nginx-lb"
  internal           = true
  load_balancer_type = "application"
  security_groups  = [aws_security_group.nginx_sg.id]
  subnets = aws_subnet.demo[*].id
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_target_group" "nginx_tg" {
  name     = "${random_string.random.id}-nginx-tg"
  target_type = "ip"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo.id
  
  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener" "nginx_listener" {
  load_balancer_arn = aws_lb.nginx_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx_tg.arn
  }
}


