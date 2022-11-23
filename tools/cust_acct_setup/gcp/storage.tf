resource "google_storage_bucket" "cp_artifact_bucket" {
  name     = var.bucket_name
  location = var.bucket_region

  project = var.project
}
