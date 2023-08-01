output "docdb_cluster_endpoint" {
  value       = aws_docdb_cluster.docdb.endpoint
  description = "The endpoint of the DocumentDB cluster"
}

output "docdb_cluster_port" {
  value       = aws_docdb_cluster.docdb.port
  description = "The port of the DocumentDB cluster"
}

output "docdb_cluster_master_password" {
  value       = random_password.password_doc.result
  description = "The generated master password for the DocumentDB cluster"
  sensitive   = true
}
