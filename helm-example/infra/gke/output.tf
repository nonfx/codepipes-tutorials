output "cluster" {
  value       = google_container_cluster.primary.name
  description = "k8s cluster name"
}

output "region" {
  value       = google_container_cluster.primary.location
  description = "k8s cluster region"
}
