resource "google_project_service" "gke_apis" {
  project  = data.google_project.project.project_id
  for_each = var.with_gke ? toset(var.gke_services) : []
  service  = each.value
  disable_on_destroy = false
}

resource "google_project_iam_binding" "gke_role_assignment" {
  count   = var.with_gke ? 1 : 0
  project = data.google_project.project.project_id
  role    = "roles/container.admin"
  members = ["serviceAccount:${google_service_account.cp_service_acct.email}"]
}
