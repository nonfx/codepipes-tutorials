provider "azurerm" {
  version = "= 3.21.1"
  features {}
}

provider "random" {}

resource "random_string" "random" {
  length    = 8
  special   = false
  min_lower = 8
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_app_service_plan" "funcs" {
  name                = "azfunc-service-plan${random_string.random.result}"
  location            = var.location
  resource_group_name = var.resource_group

  sku {
    tier = var.app_service_tier
    size = var.app_service_size
  }
}

resource "azurerm_function_app" "funcs" {
  name                       = "azfunc${random_string.random.result}"
  location                   = var.location
  resource_group_name        = var.resource_group
  app_service_plan_id        = azurerm_app_service_plan.funcs.id
  storage_account_name       = azurerm_storage_account.funcs.name
  storage_account_access_key = azurerm_storage_account.funcs.primary_access_key
}