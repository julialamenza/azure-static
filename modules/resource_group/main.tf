#---------------------------------------------------------------------------------------
# Create a resource group in Azure                                                       
#   - Create a resource group for the storage account                 
#---------------------------------------------------------------------------------------

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
