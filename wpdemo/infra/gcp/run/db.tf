
resource "google_sql_database" "main" {
  name     = "main"
  instance = google_sql_database_instance.db_primary.name
}

resource "google_sql_database_instance" "db_primary" {
  name             = "db-primary"
  database_version = "MYSQL_5_7"
  deletion_protection = false
  settings {
    tier              = var.instance_type
  }
}

resource "google_sql_user" "db_user" {
  name     = var.user
  instance = google_sql_database_instance.db_primary.name
  password = var.password
}
