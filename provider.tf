# Terraform configuration

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
  zone    = var.gcp_zone
}


terraform {
  backend "gcs" {
    bucket      = "mc-global-st"
    prefix      = "root/resources.tfsate"
    credentials = "development-369707-e64f510ac15b.json"
  }
}
