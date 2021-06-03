/******************************************
	VPC configuration
 *****************************************/
resource "google_compute_network" "network" {
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
  routing_mode            = var.routing_mode
  project                 = var.project
  description             = var.description
}

/******************************************
	Shared VPC
 *****************************************/
resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  count      = var.shared_vpc_host ? 1 : 0
  project    = var.project
  depends_on = [google_compute_network.network]
}
