
#################Tags##############################################
variable "bag" {}
variable "bapp_id" {}
variable "environment" {}
variable "name_node_id" {}
variable "project_contact_email" {}
#################Tags##############################################
#################Sagemaker Studio##################################
variable "tf_vpc_dlp_sagemaker_domain" {}
variable "tf_subnets_dlp_sagemaker_domain" {default =  [""]}
variable "domain_name" {}
variable "domain_auth_mode" {}
variable "domain_app_network_access_type" {}
variable "domain_sharing_enabled" {}
variable "domain_role_name" {}
variable "domain_kms_key_id" { 
}
#################Sagemaker Studio##################################