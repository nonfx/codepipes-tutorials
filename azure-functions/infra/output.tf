output "function_app" {
  value = "${azurerm_function_app.funcs.name}"
}

output "database_connection_string" {
  value = "Server=tcp:${azurerm_mssql_server.main.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.main.name};Persist Security Info=False;User ID=${var.mssql_server_username};Password=${random_password.password.result};MultipleActiveResultSets=True;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive = true
}

