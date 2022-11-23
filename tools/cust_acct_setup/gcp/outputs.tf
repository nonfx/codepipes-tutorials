output "codepipes_service_account_id" {
  value = google_service_account.cp_service_acct.account_id
}

output "codepipes_service_account_email" {
  value = google_service_account.cp_service_acct.email
}

output "codepipes_artifact_bucket" {
  value = google_storage_bucket.cp_artifact_bucket.name
}

output "codepipes_key_ring" {
  value = google_kms_key_ring.cp_key_ring.id
}

output "codepipes_cloud_build_topic" {
  value = google_pubsub_topic.codepipes-cloud-build-topic.id
}

output "codepipes_cloud_build_listener" {
  value = google_pubsub_subscription.codepipes-cloud-build-listener.id
}

output "codepipes_service_account_key" {
  value = google_service_account_key.cp_service_acct_key.private_key
  sensitive = true
}
