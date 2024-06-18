output "source_storage_account_url" {
  value = module.source_storage_account.primary_web_endpoint
}

output "assets_storage_account_url" {
  value = module.assets_storage_account.primary_blob_endpoint
}

output "dns_zone_name" {
  value = module.dns.dns_zone_name
}

output "cname_record_fqdn" {
  value = module.dns.cname_record_fqdn
}