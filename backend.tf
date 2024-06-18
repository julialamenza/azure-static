
 terraform {
   backend "azurerm" {
     resource_group_name      = module.resource_group.resource_group_name
     storage_account_name     = azurerm_storage_account.tfstate.name
     container_name           = azurerm_storage_container.tfstate.name
     key                      = "terraform.tfstate"
   }
 }