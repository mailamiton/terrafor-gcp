locals {
  gcp_zone = ["${var.gcp_region}a", "${var.gcp_region}b", "${var.gcp_region}c"]
}
#####################API gateway ###################
module "my_api_gateway" {
  source        = "./modules/api-gateway"
  rest_api_name = var.rest_api_name
  lambda_arn    = module.my_lambda.lambda_arn
}
#####################API gateway ###################
