provider "google-beta" {
}

terraform {
  required_version = ">= 0.12"
}

resource "google_project_service" "vpcaccess-api" {
  project = var.GOOGLE_PROJECT 
  service = "vpcaccess.googleapis.com"
}

resource "google_vpc_access_connector" "connector" {
  name          = "vpc-con"
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
}

output "connector_name" {
  value       = resource.google_vpc_access_connector.connector.name
  description = "The name of the gke cluster"
}
