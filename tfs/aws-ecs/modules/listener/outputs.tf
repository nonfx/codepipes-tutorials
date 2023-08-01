output "lb-http-listener-arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.lb-http-listener.arn
}

output "lb-https-listener-arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.lb-https-listener.arn
}
