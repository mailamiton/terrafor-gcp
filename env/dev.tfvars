###########################################
#            GCP ACCOUNT SETTING               #
###########################################
gcp_project = "nw-non-prod-mc-vr"
gcp_region  = "asia-south1"
###########################################
###############VPC#######################
#https://www.davidc.net/sites/default/subnets/subnets.html to distribute in 4094 Divisions
vpc_name               = "vr-mc-vpc"
private_subnets        = { "private-subnet-01" = "10.0.0.0/20", "private-subnet-02" = "10.0.16.0/20" }
public_subnets         = { "public-subnet-01" = "10.0.48.0/20", "public-subnet-02" = "10.0.64.0/20" }
private_default_router = "vr-mc-router"
private_default_nat    = "vr-mc-nat"
private_default_nat_ip = "vr-mc-nat-ip"
###############VPC########################
###############Shared VPC#######################
#vpc_name               = "vr-mc-vpc"
host_project     = "nw-non-prod-mc-vr"
service_projects = ["development-378505", "staging-378505", "development-369707", "staging-372908"]
###############Shared VPC#######################
###############Cloud SQL Postgres##########
instance_name     = "vrddi-dev-instance"
database_version  = "POSTGRES_14"
machine_type      = "db-custom-2-3840"
database_name     = "vrddi_db"
database_user     = "vrddi_admin"
database_password = "vrddi_admin@123!@#"
###############Cloud SQL Postgres##########
