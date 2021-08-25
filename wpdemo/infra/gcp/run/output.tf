output "connection_name" {
  description = "The connection string used by Cloud SQL Proxy, e.g. my-project:us-central1:my-db"
  value       = google_sql_database_instance.db_instance.connection_name
}
output "instance_ip_address" {
  value       = google_sql_database_instance.db_instance.ip_address
  description = "The IPv4 address assigned for the master instance"
}

output "private_address" {
  value       = google_sql_database_instance.db_instance.private_ip_address
  description = "The private IP address assigned for the master instance"
}