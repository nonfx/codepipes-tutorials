output "azure_url" {
  value = "${azurerm_storage_account.demo_storage_account.primary_web_endpoint}"
}
