##########################################################
#                      BOILERPLATE                       #
##########################################################
#                       GCP SETUP                        #
##########################################################
variable "gcp_region" {
  type        = string
  description = ""
  default     = ""
}

variable "gcp_project" {
  type        = string
  description = ""
}

##########################################################
#######################Cloud SQL Postgres###################################

variable "instance_name" {
  type        = string
  description = ""
}

variable "database_version" {
  type        = string
  description = ""
}

variable "machine_type" {
  type        = string
  description = ""
}
variable "database_name" {
  type        = string
  description = ""
}

variable "database_user" {
  type        = string
  description = ""
}

variable "database_password" {
  type        = string
  description = ""
}
#######################Cloud SQL Postgres###################################
############################VPC#############################################

variable "vpc_name" {
  type        = string
  description = ""
  default     = "main_vpc"
}

variable "private_subnets" {
  type = map(string)
  default = {
    "private-subnet-01" = "10.0.0.0/20",
    "private-subnet-02" = "10.0.16.0/20",
    "private-subnet-03" = "10.0.32.0/20",
  }
}

variable "public_subnets" {
  type = map(string)
  default = {
    "public-subnet-01" = "10.0.48.0/20",
    "public-subnet-02" = "10.0.64.0/20",
    "public-subnet-03" = "10.0.80.0/20",
  }
}
variable "private_default_nat" {
  type        = string
  description = ""
  default     = "default-nat"
}
variable "private_default_nat_ip" {
  type        = string
  description = ""
  default     = "default-nat-ip"
}
variable "private_default_router" {
  type        = string
  description = ""
  default     = "default-router"
}
############################VPC#############################################
############################Shared VPC######################################

# variable "vpc_name" {
#   type        = string
#   description = ""
#   default     = "main_vpc"
# }

variable "host_project" {
  type        = string
  description = ""
  default     = "host_project"
}

variable "service_projects" {
  type        = list(any)
  description = ""
  default     = [""]
}
############################Shared VPC######################################
