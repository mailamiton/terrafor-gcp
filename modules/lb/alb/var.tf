variable "allowed_cidr_blocks" {
  type = list(any)
}
variable "vpc_id" {
}
variable "alb_name" {
}
variable "alb_subnet" {
  type = list(any)
}
variable "target_id" {
}
