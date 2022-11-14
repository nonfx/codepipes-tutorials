resource "azurerm_storage_account" "funcs" {
  name                     = "azfunc${random_string.random.result}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}