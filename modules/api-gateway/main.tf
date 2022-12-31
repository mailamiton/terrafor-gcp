locals {
  api_config_id_prefix = "mc"
  api_id               = "demo-id"
  gateway_id           = "demo-gateway-id"
  display_name         = "demo-display"
}

resource "google_api_gateway_api" "api_gw" {
  provider     = google-beta
  api_id       = local.api_gateway_container_id
  project      = var.project_id
  display_name = local.display_name
}

resource "google_api_gateway_api_config" "api_cfg" {
  provider             = google-beta
  api                  = google_api_gateway_api.api_gw.api_id
  api_config_id_prefix = local.api_config_id_prefix
  project              = var.project_id
  display_name         = local.display_name

  openapi_documents {
    document {
      path     = "openapi.yaml"
      contents = filebase64("openapi.yml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "gw" {
  provider = google-beta
  region   = var.region
  project  = var.project_id


  api_config = google_api_gateway_api_config.api_cfg.id

  gateway_id   = local.gateway_id
  display_name = local.display_name

  depends_on = [google_api_gateway_api_config.api_cfg]
}
