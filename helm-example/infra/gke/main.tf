resource "google_service_account" "default" {
  project      = var.GOOGLE_PROJECT
  account_id   = format("%s-%s", "test-k8s", random_string.random.result)
  display_name = format("%s-%s", "test-k8s", random_string.random.result)
}

resource "google_container_cluster" "primary" {
  project            = var.GOOGLE_PROJECT
  name               = format("%s-%s", var.CLUSTER_NAME, random_string.random.result)
  location           = var.location
  initial_node_count = 1
  remove_default_node_pool = true
  node_locations = var.node_locations
  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    labels = {
      foo = "bar"
    }
    tags = ["foo", "bar"]
  }
  timeouts {
    create = "30m"
    update = "40m"
  }
}

