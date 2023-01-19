resource "google_kms_key_ring" "cp_key_ring" {
  name     = var.key_ring
  location = "global"
  project  = data.google_project.project.project_id
}
  
