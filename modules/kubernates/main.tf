#API dependency
resource "google_project_service" "container" {
  service = "container.googleapis.com"
}

resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account
resource "google_service_account" "service-a" {
  account_id = "service-a"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam
resource "google_project_iam_member" "member-role" {
  for_each = toset([
    "roles/cloudsql.admin",
    "roles/secretmanager.secretAccessor",
    "roles/datastore.owner",
    "roles/storage.admin",
    "roles/containerregistry.ServiceAgent",

  ])
  role    = each.key
  member  = "serviceAccount:${google_service_account.service-a.email}"
  project = var.gcp_project
}

#workload identity to access GCP services
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.service-a.id
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.gcp_project}.svc.id.goog[${local.kubernates_namespace}/service-a]"
}




#Local  naming convention used by resources
locals {
  cluster_name               = "demo-cluster"
  cluster_zone               = "asia-south1-a"
  cluster_other_zone         = "asia-south1-b"
  node_group_default         = "standard"
  node_group_default_vm_type = "e2-small"
  node_group_default_vm_tag  = "standard"
  node_group_spot            = "spot"
  node_group_spot_vm_type    = "e2-small"
  node_group_spot_vm_tag     = "spot-vm"
  workload_identity_config   = "development-369707.svc.id.goog"
  kubernates_namespace       = "vrddi"

}

# control plane resource
resource "google_container_cluster" "primary" {
  name                     = local.cluster_name
  location                 = local.cluster_zone
  remove_default_node_pool = true
  initial_node_count       = 1
  # network                  = google_compute_network.main.self_link
  # subnetwork               = google_compute_subnetwork.private.self_link
  network            = var.vpc_network
  subnetwork         = var.sub_vpc_network
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  networking_mode    = "VPC_NATIVE"

  # Optional, if you want multi-zonal cluster
  node_locations = [
    local.cluster_other_zone
  ]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = "REGULAR"
  }

  workload_identity_config {
    workload_pool = local.workload_identity_config
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "k8s-pod-range"
    services_secondary_range_name = "k8s-service-range"
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  #   Jenkins use case
  #   master_authorized_networks_config {
  #     cidr_blocks {
  #       cidr_block   = "10.0.0.0/18"
  #       display_name = "private-subnet-w-jenkins"
  #     }
  #   }
  depends_on = [
    google_project_service.container
  ]
}


#Node groups
resource "google_container_node_pool" "general" {
  name       = local.node_group_default
  cluster    = google_container_cluster.primary.id
  node_count = 1

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    preemptible  = false
    machine_type = local.node_group_default_vm_type

    labels = {
      role = local.node_group_default_vm_tag
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}

resource "google_container_node_pool" "spot" {
  name    = local.node_group_spot
  cluster = google_container_cluster.primary.id

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = 0
    max_node_count = 3
  }

  node_config {
    preemptible  = true
    machine_type = local.node_group_spot_vm_type

    labels = {
      team = local.node_group_spot_vm_tag
    }

    taint {
      key    = "instance_type"
      value  = "spot"
      effect = "NO_SCHEDULE"
    }

    service_account = google_service_account.kubernetes.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
}
