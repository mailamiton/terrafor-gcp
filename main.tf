locals {
  gcp_zone = ["${var.gcp_region}a", "${var.gcp_region}b", "${var.gcp_region}c"]
}
# #####################Create VPC #################
# module "my_vpc" {
#   source               = "./modules/vpc"
#   main_vpc_cidr        = var.main_vpc_cidr
#   tenancy              = var.tenancy
#   environment          = var.environment
#   private_subnets_cidr = var.private_subnets_cidr
#   public_subnets_cidr  = var.public_subnets_cidr
#   availability_zone    = local.production_availability_zones
# }
# #####################Create VPC #################
# #####################Create Lambda #################
# module "my_lambda" {
#   source          = "./modules/lambda"
#   apiarn          = module.my_api_gateway.api_gateway_arn
#   privateSubnetId = tostring(module.my_vpc.private_subnet[0].id)
#   vpc_id          = module.my_vpc.vpcId
# }
# #####################Create Lambda #################
# #####################API gateway ###################
# module "my_api_gateway" {
#   source        = "./modules/api-gateway"
#   rest_api_name = var.rest_api_name
#   lambda_arn    = module.my_lambda.lambda_arn
# }
# #####################API gateway ###################
