provider "google" {
}

terraform {
  required_version = ">= 0.12"
}


resource "google_project_service" "vpcaccess_api" {
  project = var.GOOGLE_PROJECT
  service = "vpcaccess.googleapis.com"
}

resource "google_vpc_access_connector" "connector" {
  name          = var.GOOGLE_VPC_CONNECTOR_NAME
  ip_cidr_range = "10.8.0.0/28"
  network       = "default"
  region        = "us-central1"
  depends_on    = [google_project_service.vpcaccess_api]
}
