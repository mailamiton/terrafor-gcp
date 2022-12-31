variable "main_vpc_cidr" {}
variable "tenancy" {}
variable "environment" {}
variable "availability_zone" {}
variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
}
variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}