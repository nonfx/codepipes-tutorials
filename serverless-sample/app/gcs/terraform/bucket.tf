# Specify the GCP Provider
provider "google" {
credentials = file("CREDENTIALS_FILE.json")
project = var.project_id
region  = var.region
}

# Create a GCS Bucket
resource "google_storage_bucket" "my_bucket" {
name     = var.bucket_name
location = var.region
}