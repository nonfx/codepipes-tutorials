output "s3_access_logs_bucket" {
  description = "The name of the S3 bucket for load balancer access logs"
  value       = aws_s3_bucket.s3_access_logs_bucket.bucket
}

output "lb_arn" {
  description = "The ARN of the Load Balancer"
  value       = aws_lb.lb.arn
}

output "web_acl_id" {
  description = "The ID of the AWS WAF WebACL"
  value       = module.waf.web_acl_id
}

output "cloudwatch_log_group" {
  description = "The name of the CloudWatch Log Group for WAF logs"
  value       = aws_cloudwatch_log_group.web-logs.name
}
