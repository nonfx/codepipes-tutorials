output "name" {
  value       = google_container_cluster.this.name
  description = "The name of the gke cluster"
}

output "endpoint" {
  description = "Cluster endpoint"
  value       = google_container_cluster.this.endpoint
}

output "instance_group_urls" {
  description = "List of instance group URLs which have been assigned to the cluster."
  value       = google_container_cluster.this.instance_group_urls
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = local.cluster_ca_certificate
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = local.master_version
}

output "node_pool" {
  description = "Node pool config"
  value       = google_container_node_pool.this
}
