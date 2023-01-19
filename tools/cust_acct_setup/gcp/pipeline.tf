resource "google_project_iam_custom_role" "cp_pipeline_role" {
  project     = data.google_project.project.project_id
  role_id     = var.iam_pipeline_role_name
  title       = "Code Pipes Permissions to use resources"
  description = "Role required to use Code Pipes"
  permissions = [
    "cloudbuild.builds.create",
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudkms.cryptoKeys.create",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.update",
    "cloudkms.cryptoKeyVersions.create",
    "cloudkms.cryptoKeyVersions.get",
    "cloudkms.cryptoKeyVersions.list",
    "cloudkms.cryptoKeyVersions.useToEncrypt",
    "cloudkms.keyRings.get",
    "iam.serviceAccounts.actAs",
    "pubsub.snapshots.list",
    "pubsub.subscriptions.consume",
    "pubsub.subscriptions.list",
    "pubsub.topics.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "run.services.get",
    "run.services.update",
    "storage.buckets.get",
    "storage.buckets.list",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.create",
    "storage.objects.delete",
    "serviceusage.services.use",
    "secretmanager.versions.list",
    "secretmanager.secrets.create",
    "secretmanager.secrets.delete",
    "secretmanager.versions.add",
    "secretmanager.versions.access",
    # things we should move to createRole
    "storage.buckets.create",
    "pubsub.topics.create",
    "pubsub.subscriptions.create",
  ]
}

resource "google_project_iam_custom_role" "cp_pipeline_creator_role" {
  project     = data.google_project.project.project_id
  role_id     = var.iam_creator_role_name
  title       = "Code Pipes Permissions to create resources"
  description = "Role required to create Code Pipes resources"
  permissions = [
    "cloudkms.keyRings.create",
    "pubsub.subscriptions.create",
    "pubsub.topics.attachSubscription",
    "pubsub.topics.create",
    "resourcemanager.projects.setIamPolicy",
    "run.services.create",
    "run.services.delete",
    "storage.buckets.create",
    "storage.buckets.delete",
  ]
}

resource "google_project_iam_binding" "pipeline_role_assignment" {
  project = data.google_project.project.project_id
  role    = google_project_iam_custom_role.cp_pipeline_role.id
  members = ["serviceAccount:${google_service_account.cp_service_acct.email}"]
}

resource "google_project_iam_member" "cloudbuild_role_assignment" {
  project = data.google_project.project.project_id
  role    = "roles/cloudkms.cryptoKeyDecrypter"
  member  = "serviceAccount:${data.google_project.project.number}@cloudbuild.gserviceaccount.com"
}
