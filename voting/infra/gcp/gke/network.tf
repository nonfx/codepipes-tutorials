resource "google_compute_global_address" "google-managed-services-range" {
  project       = var.GOOGLE_PROJECT
  name          = "ip-${var.network}"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = module.vpc.id
}

resource "google_service_networking_connection" "private_service_access" {
  network = module.vpc.id
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [
    google_compute_global_address.google-managed-services-range.name
  ]
}

resource "google_compute_firewall" "services-firewall" {
  project = var.GOOGLE_PROJECT
  name    = "demo-firewal-${var.network}"
  network = module.vpc.network.self_link
  allow {
    protocol = "tcp"
    ports    = ["8080", "8081", "8082", "8083", "8084", "8085"]
  }
}
