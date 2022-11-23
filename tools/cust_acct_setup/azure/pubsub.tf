resource "azurerm_servicebus_namespace" "cp_servicebus_namespace" {
  name                = var.servicebus_namespace
  location            = azurerm_resource_group.cp_resource_group.location
  resource_group_name = azurerm_resource_group.cp_resource_group.name
  sku                 = "Standard"
}

resource "azurerm_servicebus_topic" "cp_servicebus_topic" {
  name         = var.servicebus_topic_name
  namespace_id = azurerm_servicebus_namespace.cp_servicebus_namespace.id

  default_message_ttl = "P1D"
}
