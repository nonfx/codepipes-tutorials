output "name" {
  value       = module.gke.name
  description = "The name of the gke cluster"
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.gke.endpoint
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.gke.ca_certificate
}

output "master_version" {
  description = "Current master kubernetes version"
  value       = module.gke.master_version
}

output "subnets_secondary_ranges" {
  value       = module.vpc.subnets_secondary_ranges
  description = "The secondary ranges associated with these subnets"
}

output "nat_name" {
  description = "The name of the created Cloud NAT instance"
  value       = module.cloud_nat.name
}

output "router_name" {
  description = "The name of the Cloud NAT router."
  value       = module.cloud_nat.router_name
}
