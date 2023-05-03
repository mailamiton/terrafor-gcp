#API Dependency. Enable API for each service pro
resource "google_project_service" "compute_service" {
  for_each           = toset(var.service_projects)
  project            = each.value
  service            = "compute.googleapis.com"
  disable_on_destroy = false

}
#API Dependency. Enable API for host project
resource "google_project_service" "compute" {
  project            = var.host_project
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}


# Enable A Shared VPC in the host project
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project # Replace this with your host project ID in quotes
}

# To attach a first service project with host project 
resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = toset(var.service_projects)
  host_project    = google_compute_shared_vpc_host_project.host.project
  service_project = each.value # Replace this with your service project ID in quotes
}


# # Shared Network to attach 
# data "google_compute_network" "network" {
#   name    = var.vpc_name
#   project = var.project
# }


# # Shared Sub-Networks to attach 
# data "google_compute_subnetwork" "subnet" {
#   name    = "subnet1"
#   project = var.project
#   region  = "us-east1"
# }

# data "google_compute_subnetwork" "subnet1" {
#   name    = "subnet2"
#   project = var.project
#   region  = "us-east1"
# }
#Create the hosted network.
