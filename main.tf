locals {
  gcp_zone = ["${var.gcp_region}a", "${var.gcp_region}b", "${var.gcp_region}c"]
}
#####################Cloud Function ################
module "my_cloud_function" {
  source      = "./modules/cloud-function"
  gcp_region  = var.gcp_region
  gcp_project = var.gcp_project
}
#####################Cloud Function ################

#####################API gateway ###################
module "my_api_gateway" {
  source      = "./modules/api-gateway"
  gcp_region  = var.gcp_region
  gcp_project = var.gcp_project
}
#####################API gateway ###################

#####################Secret manager #################
module "my_secrect_manager" {
  source      = "./modules/secret-manager"
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region
}
#####################Secret manager #################
