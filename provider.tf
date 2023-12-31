# Terraform configuration

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}


terraform {
  backend "gcs" {
    bucket = "mc-infra-state-tf"
    #For Networking
    #prefix      = "root/resources.tfsate"
    prefix      = "root/resources.tfsate"
    credentials = "development-378505-71e9ce0d91de.json"
  }
}
