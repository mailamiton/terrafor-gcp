
output "vpc_network" {
  value = google_compute_network.main.self_link
}

output "sub_vpc_network" {
  value = google_compute_subnetwork.private.self_link
}
