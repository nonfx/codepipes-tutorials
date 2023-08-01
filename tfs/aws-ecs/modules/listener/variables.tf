variable "aws_lb_arn" {
  description = "The ARN of the Application Load Balancer"
  type        = string
}

variable "lb-listener-certificate-arn" {
  description = "The ARN of the SSL certificate to use for the HTTPS listener"
  type        = string
}

variable "default_target_group" {
  description = "The ARN of the default target group to use for the HTTPS listener"
  type        = string
}
