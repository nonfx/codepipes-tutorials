# Create a GCS Bucket
resource "google_storage_bucket" "cloudrun-codepipes" {
name     = var.bucket_name
location  =  var.region
}