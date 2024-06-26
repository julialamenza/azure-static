variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "static-website-rg"
}

variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
  default     = "West Europe"
}

variable "base_source_storage_account_name" {
  description = "The base name of the source storage account"
  type        = string
  default     = "source"
}

variable "base_assets_storage_account_name" {
  description = "The base name of the assets storage account"
  type        = string
  default     = "assets"
}

variable "source_index_document" {
  description = "The path to the source index.html file"
  type        = string
  default     = "html/index.html"
}

variable "source_error_document" {
  description = "The path to the source 404.html file"
  type        = string
  default     = "html/404.html"
}

variable "source_dummy_files" {
  description = "List of dummy files for the source storage account"
  type        = list(string)
  default     = ["source_dummy1.txt", "source_dummy2.txt", "source_dummy3.txt"]
}

variable "assets_dummy_files" {
  description = "List of dummy files for the assets storage account"
  type        = list(string)
  default     = ["assets_dummy1.txt", "assets_dummy2.txt", "assets_dummy3.txt"]
}