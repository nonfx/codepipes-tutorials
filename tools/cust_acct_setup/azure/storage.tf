resource "azurerm_storage_account" "cp_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.cp_resource_group.name
  location                 = azurerm_resource_group.cp_resource_group.location
  account_kind             = var.storage_account_kind
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  access_tier              = var.storage_account_access_tier
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "cp_storage_container" {
  name                  = var.storage_account_container
  storage_account_name  = azurerm_storage_account.cp_storage_account.name
  container_access_type = "private"
}
