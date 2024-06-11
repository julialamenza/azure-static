#---------------------------------------------------------------------------------------
# Create a static website in Azure Storage                                                           
#   - Create a storage account
#   - Create a container in the storage account
#   - Create a static website in the storage account
#   - Upload a index.html & 404.html to the container                  
#---------------------------------------------------------------------------------------

# Create storage account
resource "azurerm_storage_account" "storage" {
  for_each = {
    source = {
      container_name = "source"
      static_website = {
        index_document     = "index.html"
        error_404_document = "404.html"
      }
    },
    assets = {
      container_name = "assets"
    }
  }

  name                      = "sa${var.project_name}${var.environment}${each.key}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  account_kind              = var.account_kind
  enable_https_traffic_only = var.enable_https_traffic_only
  min_tls_version           = var.min_tls_version

  tags = var.tags
}

# Create storage containers
resource "azurerm_storage_container" "storage_container" {
  for_each = {
    source = "source"
    assets = "assets"
  }

  name                  = each.value
  storage_account_name  = azurerm_storage_account.storage[each.key].name
  container_access_type = "private"
}

# Create blobs for HTML files
resource "azurerm_storage_blob" "source_html_files" {
  for_each = fileset(var.html_files_dir, "*.html")
  name     = each.value
  type     = "Block"
  source   = "${var.html_files_dir}/${each.value}"
  content_type = "text/html"

  storage_account_name   = azurerm_storage_account.storage["source"].name
  storage_container_name = azurerm_storage_container.storage_container["source"].name
}

# Create blobs for asset TX files
resource "azurerm_storage_blob" "asset_tx_files" {
  for_each = fileset(var.assets_files_dir, "*.tx")  # Assuming tx files are in tx_files_dir
  name     = each.value
  type     = "Block"
  source   = "${var.assets_files_dir}/${each.value}"

  storage_account_name   = azurerm_storage_account.storage["assets"].name
  storage_container_name = azurerm_storage_container.storage_container["assets"].name
}
