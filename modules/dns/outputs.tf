output "dns_zone_name" {
  value = azurerm_dns_zone.dns_zone.name
}

output "cname_record_fqdn" {
  value = azurerm_dns_cname_record.cname_record.fqdn
}
