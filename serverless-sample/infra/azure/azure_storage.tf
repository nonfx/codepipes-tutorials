resource "azurerm_storage_account" "demo_storage_account" {
  name                      = "cphtmldemo${random_string.random.result}"
  resource_group_name       = var.resource_group
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  allow_blob_public_access  = true
  enable_https_traffic_only = true
}

resource "azurerm_storage_container" "artifacts_container" {
  name                  = "artifacts"
  storage_account_name  = azurerm_storage_account.demo_storage_account.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "demo_blob" {
  name                   = "test.gif"
  storage_account_name   = azurerm_storage_account.demo_storage_account.name
  storage_container_name = "artifacts"
  type                   = "Block"
  source                 = "${path.module}/test.gif"
}