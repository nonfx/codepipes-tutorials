output "codepipes_resource_group" {
  value = azurerm_resource_group.cp_resource_group.id
}

output "codepipes_client_id" {
  value = azuread_application.cp_application.application_id
}

output "codepipes_service_principal_pwd" {
  value     = azuread_service_principal_password.cp_service_principal_pwd.value
  sensitive = true
}

output "codepipes_storage_account" {
  value = azurerm_storage_account.cp_storage_account.id
}

output "codepipes_storage_container" {
  value = azurerm_storage_container.cp_storage_container.resource_manager_id
}

output "codepipes_servicebus_namespace" {
  value = azurerm_servicebus_namespace.cp_servicebus_namespace.id
}

output "codepipes_servicebus_topic" {
  value = azurerm_servicebus_topic.cp_servicebus_topic.id
}
