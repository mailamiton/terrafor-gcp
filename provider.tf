# Terraform configuration

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}


terraform {
  backend "gcs" {
    bucket = "tf-state-mc-vr"
    #For Networking
    #prefix      = "root/resources.tfsate"
    prefix      = "root/kubestate.tfsate"
    credentials = "nw-non-prod-mc-vr-d6a2b08a4528.json"
  }
}
