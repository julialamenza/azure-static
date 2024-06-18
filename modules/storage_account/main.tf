resource "azurerm_storage_account" "sa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    versioning_enabled = true
  container_delete_retention_policy {
days = 7
}
  }

  
  dynamic "static_website" {
    for_each = var.is_source ? [1] : []

    content {
      index_document     = "index.html"
      error_404_document = "404.html"
    }
  }
}

resource "azurerm_storage_container" "container" {
  name                  = "content"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
  
}

resource "azurerm_storage_blob" "index" {
  count                  = var.is_source ? 1 : 0
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.source_index_document
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "error" {
  count                  = var.is_source ? 1 : 0
  name                   = "404.html"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = var.source_error_document
  content_type           = "text/html"
}

resource "azurerm_storage_blob" "dummy_files" {
  count                  = length(var.dummy_files)
  name                   = basename(var.dummy_files[count.index])
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block"
  source                 = var.dummy_files[count.index]
}
