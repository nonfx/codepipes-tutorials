locals {
  name = var.name != null ? var.name : "${var.project_code}-${var.environment}"

  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

  master_version = var.kubernetes_version != "latest" ? var.kubernetes_version : data.google_container_engine_versions.region.latest_master_version

  // For output
  cluster_output_master_auth      = concat(google_container_cluster.this.*.master_auth, [])
  cluster_master_auth_list_layer1 = local.cluster_output_master_auth
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]
  cluster_ca_certificate          = local.cluster_master_auth_map["cluster_ca_certificate"]
}

data "google_container_engine_versions" "region" {
  project  = var.project
  location = var.location
}

resource "google_container_cluster" "this" {
  provider = google-beta

  project = var.project

  name        = local.name
  description = var.description
  resource_labels = merge(var.cluster_resource_labels,
    {
      name : local.name
      project : var.project_code
      environment : var.environment
    }
  )

  location          = var.location
  node_locations    = var.environment == "prod" ? var.node_locations : [var.node_locations[0]]
  cluster_ipv4_cidr = var.cluster_ipv4_cidr
  network           = var.network
  subnetwork        = var.subnetwork

  default_max_pods_per_node = var.default_max_pods_per_node
  initial_node_count        = var.initial_node_count

  enable_shielded_nodes    = var.enable_shielded_nodes
  min_master_version       = local.master_version
  remove_default_node_pool = var.remove_default_node_pool

  dynamic "database_encryption" {
    for_each = [
      for x in [var.secrets_encryption_kms_key] : x if var.secrets_encryption_kms_key != null
    ]

    content {
      state    = "ENCRYPTED"
      key_name = database_encryption.value
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.ip_range_pods
    services_secondary_range_name = var.ip_range_services
  }

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_start_time
    }
  }

  master_auth {
    username = var.basic_auth_username
    password = var.basic_auth_password

    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  # dynamic "master_authorized_networks_config" {
  #   for_each = local.master_authorized_networks_config
  #   content {
  #     dynamic "cidr_blocks" {
  #       for_each = master_authorized_networks_config.value.cidr_blocks
  #       content {
  #         cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
  #         display_name = lookup(cidr_blocks.value, "display_name", "")
  #       }
  #     }
  #   }
  # }


  private_cluster_config {
    enable_private_endpoint = var.enable_private_endpoint
    enable_private_nodes    = var.enable_private_nodes
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    http_load_balancing {
      disabled = ! var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = ! var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = ! var.network_policy
    }
  }

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }

  workload_identity_config {
    identity_namespace = "${var.project}.svc.id.goog"
  }
}
