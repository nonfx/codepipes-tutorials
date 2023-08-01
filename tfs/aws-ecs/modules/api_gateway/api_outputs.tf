# Output API Gateway custom domain URL and API key value
output "api_gateway_url" {
  value = aws_api_gateway_domain_name.domain_name.cloudfront_domain_name
}

output "api_key_value" {
  value = aws_api_gateway_api_key.api_key.value
  sensitive = true
}
