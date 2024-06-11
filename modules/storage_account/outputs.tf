#---------------------------------------------------------------------------------------
# Output values from the storage_account module
#---------------------------------------------------------------------------------------
# Out put the storrage account name from "azurerm_storage_account" "sa_static_site"
output "storage_account_name" {
  value = {
    for key, account in azurerm_storage_account.storage : key => account.name
  }
}
output "storage_account_id" {
  value = {
    for key, account in azurerm_storage_account.storage : key => account.id
  }
}