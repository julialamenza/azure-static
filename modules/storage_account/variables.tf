variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure location to deploy the resources"
  type        = string
}

variable "source_index_document" {
  description = "The path to the source index.html file"
  type        = string
  default     = ""
}

variable "source_error_document" {
  description = "The path to the source 404.html file"
  type        = string
  default     = ""
}

variable "dummy_files" {
  description = "List of dummy files to upload"
  type        = list(string)
}

variable "is_source" {
  description = "Flag to indicate if this is the source storage account"
  type        = bool
  default     = false
}
