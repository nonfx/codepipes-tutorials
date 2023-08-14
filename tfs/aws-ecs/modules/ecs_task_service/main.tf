locals {
  extract_resource_name = "${var.common_name_prefix}-${var.environment}-${var.number}"
}

resource "aws_ecs_task_definition" "task-definition" {
  family                   = "${var.apps}-task-definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = var.role_arn
  task_role_arn            = var.role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.apps}"
      image     = "public.ecr.aws/nginx/nginx:stable"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
        }
      ]

      logConfiguration = {
        logDriver : "awslogs",
        options : {
          awslogs-group : "${aws_cloudwatch_log_group.logs.name}",
          awslogs-region : "ap-south-1",
          awslogs-stream-prefix : "ecs"
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  tags = merge(
    {
      "Name" = format("%s", "${var.apps}-task-definition")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

  lifecycle {
    ignore_changes = [container_definitions]
  }


}

resource "aws_ecs_service" "service" {
  name            = "${var.apps}-service"
  cluster         = var.ecs_cluster
  task_definition = aws_ecs_task_definition.task-definition.arn

  desired_count                     = 1
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = try(length(var.site), 0) > 0 ? 15 : null
  enable_execute_command            = var.environment != "production"

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  dynamic "load_balancer" {
    # Check if site is empty or null
    for_each = try(length(var.site), 0) > 0 ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.apps
      container_port   = 3000
    }
  }

  tags = merge(
    {
      "Name" = format("%s", "${var.apps}-service")
    },
    {
      environment = var.environment
    },
    var.tags,
  )

  lifecycle {
    ignore_changes = [task_definition]
  }

}


resource "aws_appautoscaling_target" "target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${var.ecs_cluster}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "scale-cpu" {
  name               = "scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.target.resource_id
  scalable_dimension = aws_appautoscaling_target.target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 70
  }
}

resource "random_id" "aws_cloudwatch_log_group_id" {
  byte_length = 2
}

resource "aws_cloudwatch_log_group" "logs" {
  name              = "/fargate/service/${var.apps}-logs-${random_id.aws_cloudwatch_log_group_id.hex}"
  retention_in_days = 365
}
