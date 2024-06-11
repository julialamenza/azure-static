// modules/website/variables.tf
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "dns_zone_name" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "cname_record" {
  type = string
}
