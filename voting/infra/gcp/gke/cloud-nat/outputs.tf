output "name" {
  description = "The name of the Cloud NAT created."
  value       = google_compute_router_nat.main.name
}

output "nat_ip_allocate_option" {
  description = "The NAT IP allocation mode."
  value       = google_compute_router_nat.main.nat_ip_allocate_option
}

output "region" {
  description = "The region of Cloud NAT."
  value       = google_compute_router_nat.main.region
}

output "router_name" {
  description = "The name of the Cloud NAT router."
  value       = google_compute_router_nat.main.router
}
