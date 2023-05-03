#API dependency
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
}


#Local  naming convention used by resources
#locals {
#private_first_subnet   = "private-subnet-01"
#private_first_cidr     = "10.0.0.0/18"
#private_default_router = "default-router"
#private_default_nat    = "default-nat"
#private_default_nat_ip = "default-nat-ip"
#}

# Create VPC
resource "google_compute_network" "main" {
  name                            = var.vpc_name
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false
  mtu                             = 1460
  delete_default_routes_on_create = false

  depends_on = [
    google_project_service.compute
    #google_project_service.container
  ]
}



# Subnets start
resource "google_compute_subnetwork" "private" {
  for_each = var.private_subnets

  name          = each.key
  ip_cidr_range = each.value
  region        = var.gcp_region
  network       = google_compute_network.main.id
  // For access to internet from VM's
  private_ip_google_access = true

  # secondary_ip_range {
  #   range_name    = "k8s-pod-range"
  #   ip_cidr_range = "10.48.0.0/14"
  # }
  # secondary_ip_range {
  #   range_name    = "k8s-service-range"
  #   ip_cidr_range = "10.52.0.0/20"
  # }
}

resource "google_compute_subnetwork" "public" {
  for_each = var.public_subnets

  name          = each.key
  ip_cidr_range = each.value
  region        = var.gcp_region
  network       = google_compute_network.main.id

  # secondary_ip_range {
  #   range_name    = "k8s-pod-range"
  #   ip_cidr_range = "10.48.0.0/14"
  # }
  # secondary_ip_range {
  #   range_name    = "k8s-service-range"
  #   ip_cidr_range = "10.52.0.0/20"
  # }
}
# Subnets end

# #Router 
# resource "google_compute_router" "router" {
#   name    = var.private_default_router
#   region  = var.gcp_region
#   network = google_compute_network.main.id
# }

# # External IP For NAT
# resource "google_compute_address" "nat" {
#   name         = var.private_default_nat_ip
#   address_type = "EXTERNAL"
#   network_tier = "STANDARD"

#   depends_on = [google_project_service.compute]
# }


#NAT for access to internet
# resource "google_compute_router_nat" "nat" {
#   for_each = google_compute_subnetwork.private
#   name     = var.private_default_nat
#   router   = google_compute_router.router.name
#   region   = var.gcp_region

#   source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
#   nat_ip_allocate_option             = "AUTO_ONLY"

#   subnetwork {
#     name                    = google_compute_subnetwork.private[each.key].id
#     source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
#   }

#   nat_ips = [google_compute_address.nat.self_link]
# }



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
