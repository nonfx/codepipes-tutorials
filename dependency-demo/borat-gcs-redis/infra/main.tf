provider "google" {
}

terraform {
  required_version = ">= 0.12"
}

resource "random_integer" "subnet_suffix" {
  min = 0
  max = 15
}

locals {
  cidr_suffix = [for i in range(16): i]
  cidr_ips = [for i in range(16): "10.8.${i}.0/28" ]
  cidr_with_suffix = [for i in range(16): "${local.cidr_ips[i]}" ]
}

resource "google_project_service" "vpcaccess_api" {
  project = var.GOOGLE_PROJECT
  service = "vpcaccess.googleapis.com"
  disable_on_destroy = false
}

resource "google_vpc_access_connector" "connector" {
  project = var.GOOGLE_PROJECT
  name          = format("%s-%s", var.GOOGLE_VPC_CONNECTOR_NAME, random_string.random.result)
  ip_cidr_range = local.cidr_with_suffix[random_integer.random.result]
  network       = "default"
  region        = "us-central1"
  depends_on    = [google_project_service.vpcaccess_api]
}

output "connector_name" {
  value       = resource.google_vpc_access_connector.connector.name
  description = "The name of the gke cluster"
}
