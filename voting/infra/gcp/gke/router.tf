resource "google_compute_router" "router" {
  project = var.GOOGLE_PROJECT
  region  = var.location
  name    = "${var.project_code}-${var.environment}-router"
  network = module.vpc.network.self_link
  bgp {
    asn = 64514
  }
}
