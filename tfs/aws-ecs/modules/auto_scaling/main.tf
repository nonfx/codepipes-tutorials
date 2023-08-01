resource "aws_appautoscaling_target" "web-target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${var.ecs-cluster.name}/${var.ecs-web-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_target" "app-target" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${var.ecs-cluster.name}/${var.ecs-app-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "web-scale-cpu" {
  name               = "web-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web-target.resource_id
  scalable_dimension = aws_appautoscaling_target.web-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 25
  }
}


resource "aws_appautoscaling_policy" "app-scale-cpu" {
  name               = "app-scale-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.app-target.resource_id
  scalable_dimension = aws_appautoscaling_target.app-target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.app-target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 25
  }
}