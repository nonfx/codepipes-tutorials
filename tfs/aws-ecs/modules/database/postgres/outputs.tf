#DB Output
output "db_password" {
  value = random_password.password_postgres.result
  sensitive = true
}

output "db_adress" {
  value = aws_db_instance.db.address
}

output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_name" {
  value = aws_db_instance.db.db_name
}

output "db_port" {
  value = aws_db_instance.db.port
}

output "db_username" {
  value = aws_db_instance.db.username
}