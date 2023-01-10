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

#####################Cloud Storage #################
module "my_cloud_manager" {
  source      = "./modules/cloud-storage"
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region
}
#####################Cloud Storage #################

#####################VPC #################
module "my_cloud_vpc" {
  source      = "./modules/vpc"
  gcp_project = var.gcp_project
  gcp_region  = var.gcp_region
}
#####################VPC #################

#################Kubernates #################
module "my_kubernates" {
  source          = "./modules/kubernates"
  gcp_project     = var.gcp_project
  gcp_region      = var.gcp_region
  vpc_network     = module.my_cloud_vpc.vpc_network
  sub_vpc_network = module.my_cloud_vpc.sub_vpc_network
}
#################Kubernates #################
