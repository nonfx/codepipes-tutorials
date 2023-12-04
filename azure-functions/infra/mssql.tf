resource "azurerm_mssql_server" "main" {
  name                         = "${var.mssql_server_name}-${random_string.random.result}"
  resource_group_name          = var.resource_group
  location                     = var.location
  version                      = var.mssql_server_version
  administrator_login          = var.mssql_server_username
  administrator_login_password = random_password.password.result
  minimum_tls_version          = var.mssql_Server_minimum_tls_version

  tags = var.tags
}

resource "azurerm_mssql_database" "main" {
  name           = "${var.mssql_server_name}-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = var.mssql_db_collation
  max_size_gb    = var.mssql_db_max_size_gb
  read_scale     = var.mssql_read_scale
  sku_name       = var.mssql_db_sku_name
  zone_redundant = var.mssql_db_zone_redundant
  tags           = var.tags
  min_capacity   = 0.5
  auto_pause_delay_in_minutes = 60
}
