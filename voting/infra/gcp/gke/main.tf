module "vpc" {
  source       = "./vpc"
  project      = var.GOOGLE_PROJECT
  network_name = var.network
  routing_mode = "REGIONAL"
  subnets = [
    {
      subnet_name           = var.subnetwork
      subnet_ip             = var.subnet_ip
      subnet_region         = var.location
      subnet_private_access = true
      subnet_flow_logs      = false
    }
  ]
  secondary_ranges = {
    "${var.subnetwork}" = [
      {
        range_name    = var.ip_range_pods
        ip_cidr_range = "10.64.0.0/16"
      },
      {
        range_name    = var.ip_range_services
        ip_cidr_range = "10.241.0.0/22"
      }
    ]
  }
}


module "cloud_nat" {
  source = "./cloud-nat"

  project = var.GOOGLE_PROJECT

  region = var.location
  router = google_compute_router.router.name

  project_code = var.project_code
  environment  = var.environment
}

data "google_compute_zones" "available" {
  region  = var.location
  project = var.GOOGLE_PROJECT
}

module "gke" {
  source                     = "./gke"
  name                       = var.name
  project                    = var.GOOGLE_PROJECT
  project_code               = var.project_code
  environment                = var.environment
  location                   = var.location
  node_locations             = data.google_compute_zones.available.names
  master_ipv4_cidr_block     = var.cluster_ipv4_cidr
  ip_range_pods              = var.ip_range_pods
  ip_range_services          = var.ip_range_services
  master_authorized_networks = var.master_authorized_networks
  network                    = module.vpc.network_name
  subnetwork                 = var.subnetwork
  description                = "This cluster is for demo"

  kubernetes_version = var.kubernetes_version
  node_pools = {
    main = {
      auto_upgrade       = true
      auto_repair        = true
      initial_node_count = 1
      autoscaling        = false
      max_pods_per_node  = 110
      node_count         = 1
      image_type         = "COS"
      machine_type       = "n1-standard-4"
      local_ssd_count    = 0
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      premptible         = var.environment == "prod" ? false : true
      oauth_scopes = [
        "https://www.googleapis.com/auth/compute",
        "https://www.googleapis.com/auth/devstorage.read_only",
        "https://www.googleapis.com/auth/logging.write",
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/servicecontrol",
        "https://www.googleapis.com/auth/service.management.readonly",
        "https://www.googleapis.com/auth/trace.append",
      ]
      enable_secure_boot          = true
      enable_integrity_monitoring = true
      service_account             = null
      boot_disk_kms_key           = null
    }
  }

  node_pools_metadata = {
    "disable-legacy-endpoints" = "true"
  }
  depends_on = [module.vpc]
}


