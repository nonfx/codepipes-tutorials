data "google_project" "project" {
  project_id = var.project
}

resource "google_project_service" "apis" {
  project  = data.google_project.project.name
  for_each = toset(var.api_services)
  service  = each.value
  disable_on_destroy = false
}

resource "google_service_account" "cp_service_acct" {
  project      = data.google_project.project.name
  account_id   = var.service_account_name
  display_name = "Code Pipes Service Account"
}

resource "google_service_account_key" "cp_service_acct_key" {
  service_account_id = google_service_account.cp_service_acct.name
}
