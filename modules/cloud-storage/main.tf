locals {
  bucket_name = "vriddhi_dev"
}
resource "google_storage_bucket" "static_site" {
  name          = local.bucket_name
  location      = var.gcp_region
  force_destroy = true
  website {
    main_page_suffix = "index.html"
  }
  cors {
    origin          = ["*"]
    method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}
resource "google_storage_bucket_object" "static_site_src" {
  name   = "index.html"
  source = "${path.module}/static/vriddhi/index.html"
  bucket = google_storage_bucket.static_site.name
}
resource "google_storage_default_object_access_control" "public_rule" {
  bucket = google_storage_bucket.static_site.name
  role   = "READER"
  entity = "allUsers"
}
