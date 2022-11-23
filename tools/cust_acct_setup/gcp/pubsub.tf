resource "google_pubsub_topic" "codepipes-cloud-build-topic" {
  name    = var.cloud_build_topic_name
  project = var.project
}

resource "google_pubsub_subscription" "codepipes-cloud-build-listener" {
  name    = var.cloud_build_subscription_name
  topic   = google_pubsub_topic.codepipes-cloud-build-topic.name
  project = var.project

  message_retention_duration = "172800s"
  ack_deadline_seconds       = 10

  expiration_policy {
    ttl = "604800s"
  }
  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }
}
