#API dependency
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}


#Local  naming convention used by resources
locals {
  private_first_subnet   = "private-subnet-01"
  private_first_cidr     = "10.0.0.0/18"
  private_default_router = "default-router"
  private_default_nat    = "default-nat"
  private_default_nat_ip = "default-nat-ip"
}

# Create VPC
resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute
    #google_project_service.container
  ]
}



# Subnets
resource "google_compute_subnetwork" "private" {
  name          = local.private_first_subnet
  ip_cidr_range = local.private_first_cidr
  region        = var.gcp_region
  network       = google_compute_network.main.id
  // For access to internet from VM's
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "k8s-pod-range"
    ip_cidr_range = "10.48.0.0/14"
  }
  secondary_ip_range {
    range_name    = "k8s-service-range"
    ip_cidr_range = "10.52.0.0/20"
  }
}


#Router 
resource "google_compute_router" "router" {
  name    = local.private_default_router
  region  = var.gcp_region
  network = google_compute_network.main.id
}

# External IP For NAT
resource "google_compute_address" "nat" {
  name         = local.private_default_nat_ip
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"

  depends_on = [google_project_service.compute]
}


#NAT for access to internet
resource "google_compute_router_nat" "nat" {
  name   = local.private_default_nat
  router = google_compute_router.router.name
  region = var.gcp_region

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.private.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.nat.self_link]
}



#Firewall
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
