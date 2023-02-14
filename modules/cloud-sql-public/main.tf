resource "google_sql_database_instance" "master" {
  name             = var.instance_name
  database_version = var.database_version
  region           = var.gcp_region

  settings {
    tier = var.machine_type
  }
}

resource "google_sql_database" "database" {
  name     = var.database_name
  instance = google_sql_database_instance.master.name
}

resource "google_sql_user" "users" {
  name     = var.database_user
  instance = google_sql_database_instance.master.name
  host     = "*"
  password = var.database_password
}

