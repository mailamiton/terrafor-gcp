resource "google_project_service" "secretmanager" {
  provider = google-beta
  project  = var.gcp_project
  service  = "secretmanager.googleapis.com"
}

resource "google_secret_manager_secret" "my-secret" {
  provider  = google-beta
  project   = var.gcp_project
  secret_id = "mcdb-dev-db"

  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager]
}

resource "google_secret_manager_secret_version" "my-secret-1" {
  provider = google-beta

  secret      = google_secret_manager_secret.my-secret.id
  secret_data = "{\"username\": \"postgres\", \"password\": \"amit1234!\",  \"engine\": \"postgresql\", \"host\": \"34.100.134.205\", \"port\": \"5432\", \"dbname\": \"mcdb\", \"dbInstanceIdentifier\": \"moneyclub-production\"}"
}

resource "google_secret_manager_secret_iam_member" "my-app" {
  provider = google-beta

  secret_id = google_secret_manager_secret.my-secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:development-369707@appspot.gserviceaccount.com" #"development-369707@appspot.gserviceaccount.com" # or serviceAccount:my-app@...
}
