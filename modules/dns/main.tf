resource "azurerm_dns_zone" "dns_zone" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_dns_cname_record" "cname_record" {
  name                = var.subdomain_name
  zone_name           = azurerm_dns_zone.dns_zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  record              = var.storage_account_hostname
}
