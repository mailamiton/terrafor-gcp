locals {
  gcp_zone = ["${var.gcp_region}a", "${var.gcp_region}b", "${var.gcp_region}c"]
}
# #####################Cloud Function ################
# module "my_cloud_function" {
#   source      = "./modules/cloud-function"
#   gcp_region  = var.gcp_region
#   gcp_project = var.gcp_project
# }
# #####################Cloud Function ################

# #####################API gateway ###################
module "my_api_gateway" {
  source      = "./modules/api-gateway"
  gcp_region  = var.gcp_region
  gcp_project = var.gcp_project
}
# #####################API gateway ###################

# #####################Secret manager #################
# module "my_secrect_manager" {
#   source      = "./modules/secret-manager"
#   gcp_project = var.gcp_project
#   gcp_region  = var.gcp_region
# }
# #####################Secret manager #################

# #####################Cloud Storage #################
# module "my_cloud_manager" {
#   source      = "./modules/cloud-storage"
#   gcp_project = var.gcp_project
#   gcp_region  = var.gcp_region
# }
# #####################Cloud Storage #################

#####################VPC #################
# module "my_cloud_vpc" {
#   source                 = "./modules/vpc"
#   vpc_name               = var.vpc_name
#   gcp_project            = var.gcp_project
#   gcp_region             = var.gcp_region
#   private_subnets        = var.private_subnets
#   public_subnets         = var.public_subnets
#   private_default_router = var.private_default_router
#   private_default_nat_ip = var.private_default_nat_ip
#   private_default_nat    = var.private_default_nat
# }
# #####################VPC #################
# #####################Shared VPC #################
# module "my_cloud_service_vpc" {
#   source           = "./modules/shared-vpc"
#   vpc_name         = var.vpc_name
#   gcp_project      = var.gcp_project
#   gcp_region       = var.gcp_region
#   host_project     = var.host_project
#   service_projects = var.service_projects
#   depends_on       = [module.my_cloud_vpc]

# }
# #####################Shared VPC #################


#################Kubernates #################
# module "my_kubernates" {
#   source          = "./modules/kubernates"
#   gcp_project     = var.gcp_project
#   gcp_region      = var.gcp_region
#   vpc_network     = "vr-mc-vpc"
#   sub_vpc_network = "public-subnet-01"
#   #For VPC Creation from terrform
#   #vpc_network     = module.my_cloud_vpc.vpc_network
#   #sub_vpc_network = module.my_cloud_vpc.sub_vpc_network
# }
#################Kubernates #################


# #################Cloud SQL#################
# module "cloud_sql" {
#   source            = "./modules/cloud-sql-public"
#   gcp_project       = var.gcp_project
#   gcp_region        = var.gcp_region
#   instance_name     = var.instance_name
#   database_version  = var.database_version
#   machine_type      = var.machine_type
#   database_name     = var.database_name
#   database_user     = var.database_user
#   database_password = var.database_password
# }
# #################Cloud SQL#################
