resource "google_project_service" "cloudrun_apis" {
  project  = data.google_project.project.project_id
  for_each = var.with_cloudrun ? toset(var.cloudrun_services) : []
  service  = each.value
  disable_on_destroy = false
}

resource "google_project_iam_custom_role" "cp_cloudrun_role" {
  count       = var.with_cloudrun ? 1 : 0
  project     = data.google_project.project.project_id
  role_id     = var.iam_cloudrun_role_name
  title       = "Code Pipes CloudRun Permissions"
  description = "Role required for cloudrun service for Code Pipes."
  permissions = [
    "serviceusage.services.use",
    "secretmanager.versions.list",
    "secretmanager.secrets.create",
    "secretmanager.secrets.delete",
    "secretmanager.versions.add",
    "secretmanager.versions.access",
    "run.revisions.delete",
    "run.revisions.get",
    "run.revisions.list",
    "run.routes.get",
    "run.routes.list",
    "run.services.create",
    "run.services.delete",
    "run.services.get",
    "run.services.getIamPolicy",
    "run.services.list",
    "run.services.setIamPolicy",
    "run.services.update"
  ]
}

resource "google_project_iam_binding" "cloudrun_role_assignment" {
  count   = var.with_cloudrun ? 1 : 0
  project = data.google_project.project.project_id
  role    = google_project_iam_custom_role.cp_cloudrun_role[0].id
  members = ["serviceAccount:${google_service_account.cp_service_acct.email}"]
}
