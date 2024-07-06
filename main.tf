module "resource_group" {
  source              = "./modules/resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}


module "source_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_source_storage_account_name}${random_string.source_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  source_index_document   = "${path.root}/html/index.html"
  source_error_document   = "${path.root}/html/404.html"
  dummy_files             = [for file in var.source_dummy_files : "${path.root}/files/${file}"]
  is_source               = true
}

module "assets_storage_account" {
  source                  = "./modules/storage_account"
  storage_account_name    = "${var.base_assets_storage_account_name}${random_string.assets_suffix.result}"
  resource_group_name     = module.resource_group.resource_group_name
  location                = module.resource_group.resource_group_location
  dummy_files             = [for file in var.assets_dummy_files : "${path.root}/files/${file}"]
  is_source               = false
}

resource "random_string" "source_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "random_string" "assets_suffix" {
  length  = 8
  special = false
  upper   = false
}
module "dns" {
  source                    = "./modules/dns"
  resource_group_name       = module.resource_group.resource_group_name
  location                  = var.location
  domain_name               = "jlamenza.com"
  subdomain_name            = "test"
  storage_account_hostname  = local.storage_account_hostname
}
