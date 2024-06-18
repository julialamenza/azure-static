locals {
  storage_account_hostname = regex("^https?://([^/]+)", module.source_storage_account.primary_web_endpoint)[0]
}