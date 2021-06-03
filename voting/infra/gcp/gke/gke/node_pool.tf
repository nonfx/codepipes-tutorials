locals {
  default_node_pool_name = "${var.project_code}-${var.environment}-node-pool"
}

resource "google_container_node_pool" "this" {
  provider = google-beta
  project  = var.project

  for_each = var.node_pools

  name     = lookup(each.value, "name", "${local.default_node_pool_name}-${each.key}")
  location = var.location

  cluster = google_container_cluster.this.name

  version = lookup(each.value, "auto_upgrade", false) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.this.min_master_version,
  )

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", false)
  }

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 50)
    }
  }

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)
  node_count        = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  node_config {
    image_type   = lookup(each.value, "image_type", "COS")
    machine_type = lookup(each.value, "machine_type", "e2-medium")

    labels = merge(var.cluster_resource_labels,
      {
        name : local.name
        project : var.project_code
        environment : var.environment
      }
    )
    metadata = var.node_pools_metadata
    tags     = var.node_pools_tags

    local_ssd_count   = lookup(each.value, "local_ssd_count", 0)
    disk_size_gb      = lookup(each.value, "disk_size_gb", 50)
    disk_type         = lookup(each.value, "disk_type", "pd-standard")
    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", null)

    service_account = lookup(each.value, "service_account", null)
    preemptible     = lookup(each.value, "preemptible", false)
    oauth_scopes    = lookup(each.value, "oauth_scopes", null)

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}
