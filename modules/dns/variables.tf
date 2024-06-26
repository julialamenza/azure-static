variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
}

variable "domain_name" {
  description = "The domain name to create the DNS zone for"
  type        = string
}

variable "subdomain_name" {
  description = "The subdomain name to create the CNAME record for"
  type        = string
}

variable "storage_account_hostname" {
  description = "The hostname of the Azure Storage Account static website"
  type        = string
}
