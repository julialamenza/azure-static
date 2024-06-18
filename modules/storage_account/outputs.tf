output "primary_web_endpoint" {
  value = azurerm_storage_account.sa.primary_web_endpoint
}

output "primary_blob_endpoint" {
  value = azurerm_storage_account.sa.primary_blob_endpoint
}
