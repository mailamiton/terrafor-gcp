variable "gcp_project" {
  type        = string
  description = ""
}


variable "gcp_region" {
  type        = string
  description = ""
  default     = ""
}

variable "vpc_name" {
  type        = string
  description = ""
  default     = "main_vpc"
}

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
