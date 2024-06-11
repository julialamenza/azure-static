// modules/website/outputs.tf
output "dns_name" {
  value = "${var.subdomain}.${var.dns_zone_name}"
}
