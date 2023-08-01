output "lb-sg-id" {
  value = aws_security_group.lb-sg.id
}

output "db-sg-id" {
  value = aws_security_group.db-sg.id
}

output "web-sg-id" {
  value = aws_security_group.web-sg.id
}

output "app-sg-id" {
  value = aws_security_group.app-sg.id
}

output "vpc-endpoint-sg-id" {
  value = aws_security_group.vpc-endpoint-sg.id
}