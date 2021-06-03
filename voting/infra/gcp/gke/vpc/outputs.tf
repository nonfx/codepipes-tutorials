output "network" {
  value       = google_compute_network.network
  description = "The created network"
}
output "id" {
  value       = google_compute_network.network.id
  description = "The created network id"
}

output "subnets" {
  value       = google_compute_subnetwork.subnetwork
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets."
}

output "network_name" {
  value       = google_compute_network.network.name
  description = "The name of the VPC being created"
}

output "network_self_link" {
  value       = google_compute_network.network.self_link
  description = "The URI of the VPC being created"
}

output "subnets_names" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.name]
  description = "The names of the subnets being created"
}

output "subnets_ips" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.ip_cidr_range]
  description = "The IPs and CIDRs of the subnets being created"
}

output "subnets_self_links" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.self_link]
  description = "The self-links of subnets being created"
}

output "subnets_regions" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.region]
  description = "The region where the subnets will be created"
}

output "subnets_private_access" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.private_ip_google_access]
  description = "Whether the subnets will have access to Google API's without a public IP"
}

output "subnets_flow_logs" {
  value       = [for network in google_compute_subnetwork.subnetwork : length(network.log_config) != 0 ? true : false]
  description = "Whether the subnets will have VPC flow logs enabled"
}

output "subnets_secondary_ranges" {
  value       = [for network in google_compute_subnetwork.subnetwork : network.secondary_ip_range]
  description = "The secondary ranges associated with these subnets"
}

