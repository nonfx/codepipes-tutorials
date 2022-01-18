output "gcp_url" {
  value = "${random_string.random.result}-${var.orgname}-${var.what_to_say}"
}
