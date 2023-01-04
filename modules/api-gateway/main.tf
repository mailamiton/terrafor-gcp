locals {
  api_config_id_prefix = "mc"
  api_id               = "demo-id"
  gateway_id           = "demo-gateway-id"
  display_name         = "demo-display"
  gateway_location     = "asia-northeast1"
}

resource "google_project_service" "api" {
  service            = "apigateway.googleapis.com"
  disable_on_destroy = false
}


resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = local.api_id
  project      = var.gcp_project
  display_name = local.display_name
  depends_on   = [google_project_service.api]
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider             = google-beta
  api                  = google_api_gateway_api.api_gw.api_id
  api_config_id_prefix = local.api_config_id_prefix
  project              = var.gcp_project
  display_name         = local.display_name

  openapi_documents {
    document {
      path     = "${path.module}/openapi.yaml"
      contents = filebase64("${path.module}/openapi.yaml")
    }
  }
  # lifecycle {
  #   create_before_destroy = true
  # }
}

resource "google_api_gateway_gateway" "gw" {
  provider = google-beta
  region   = local.gateway_location
  project  = var.gcp_project


  api_config = google_api_gateway_api_config.api_cfg.id

  gateway_id   = local.gateway_id
  display_name = local.display_name

  depends_on = [google_api_gateway_api_config.api_cfg]
}
