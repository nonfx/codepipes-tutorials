resource "google_storage_bucket" "storage_bucket" {
  provider = google-beta
  location = var.BUCKET_LOCATION
  name = "cloud-run-${random_string.random.result}"
  force_destroy = true
  project = var.GOOGLE_PROJECT
}

resource "google_storage_bucket_object" "object" {
  bucket = google_storage_bucket.storage_bucket.name
  name    = "test.gif"
  source = "${path.module}/test.gif"
}
