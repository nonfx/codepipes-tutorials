provider "google" {
}

terraform {
  required_version = ">= 0.12"
}

resource "google_project_service" "vpcaccess_api" {
  project = var.GOOGLE_PROJECT
  service = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_vpc_access_connector" "connector" {
  project = var.GOOGLE_PROJECT
  name          = format("%s-%s", var.GOOGLE_VPC_CONNECTOR_NAME, random_string.random.result)
  ip_cidr_range = "${cidrsubnet("10.8.0.0/16", 4, random_integer)}" 
  network       = "default"
  region        = "us-central1"
  depends_on    = [google_project_service.vpcaccess_api]
}

output "connector_name" {
  value       = resource.google_vpc_access_connector.connector.name
  description = "The name of the gke cluster"
}
