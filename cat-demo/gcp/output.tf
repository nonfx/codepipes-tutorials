output "gcp_url" {
  value = "http://storage.cloud.google.com/${google_storage_bucket.website_bucket.name}/index.html"
}
