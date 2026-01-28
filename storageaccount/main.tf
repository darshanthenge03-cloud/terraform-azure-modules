resource "azurerm_storage_account" "this" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location

  account_tier             = var.account_tier
  account_replication_type = var.replication_type
  account_kind             = var.account_kind

  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"

  allow_blob_public_access = var.allow_blob_public_access

  tags = var.tags
}
