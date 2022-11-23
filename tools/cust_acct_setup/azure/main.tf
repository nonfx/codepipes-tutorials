data "azuread_client_config" "current" {}

resource "azurerm_resource_group" "cp_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_application" "cp_application" {
  display_name = var.application_name
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "cp_service_principal" {
  application_id               = azuread_application.cp_application.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]

  feature_tags {
    enterprise = true
    gallery    = true
  }
}

resource "azuread_service_principal_password" "cp_service_principal_pwd" {
  service_principal_id = azuread_service_principal.cp_service_principal.object_id
}
