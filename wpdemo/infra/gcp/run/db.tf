
resource "google_sql_database" "main" {
  name     = "main"
  instance = google_sql_database_instance.db_instance.name
}

resource "google_sql_database_instance" "db_instance" {
  name             = var.db_instance_name
  database_version = "MYSQL_5_7"
  deletion_protection = false
  settings {
    tier              = var.db_instance_type
  }
}

resource "google_sql_user" "db_user" {
  name     = var.db_user
  instance = google_sql_database_instance.db_instance.name
  password = var.db_password
}
