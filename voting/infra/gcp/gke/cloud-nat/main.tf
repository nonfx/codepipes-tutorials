locals {
  name = var.name != null ? var.name : "nat-${var.project_code}-${var.environment}"

  nat_ips_length                 = length(var.nat_ips)
  default_nat_ip_allocate_option = local.nat_ips_length > 0 ? "MANUAL_ONLY" : "AUTO_ONLY"

  # locals for google_compute_router_nat
  nat_ip_allocate_option = var.nat_ip_allocate_option ? var.nat_ip_allocate_option : local.default_nat_ip_allocate_option
}

resource "google_compute_router_nat" "main" {
  project = var.project
  region  = var.region

  name                               = local.name
  router                             = var.router
  nat_ip_allocate_option             = local.nat_ip_allocate_option
  nat_ips                            = var.nat_ips
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  min_ports_per_vm                   = var.min_ports_per_vm
  udp_idle_timeout_sec               = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec              = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec   = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec    = var.tcp_transitory_idle_timeout_sec

  dynamic "subnetwork" {
    for_each = var.subnetworks
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = contains(subnetwork.value.source_ip_ranges_to_nat, "LIST_OF_SECONDARY_IP_RANGES") ? subnetwork.value.secondary_ip_range_names : []
    }
  }

  dynamic "log_config" {
    for_each = var.log_config_enable == true ? [{
      enable = var.log_config_enable
      filter = var.log_config_filter
    }] : []

    content {
      enable = log_config.value.enable
      filter = log_config.value.filter
    }
  }

}
