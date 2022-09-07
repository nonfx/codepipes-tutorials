resource "azurerm_storage_account" "demo_storage_account" {
  name                      = "cphtmldemo${random_string.random.result}"
  resource_group_name       = var.resource_group
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  allow_nested_items_to_be_public  = true
  enable_https_traffic_only = true

  static_website {
    index_document = "index.html"
  }
}

resource "azurerm_storage_blob" "demo_blob" {
  name                   = "index.html"
  storage_account_name   = azurerm_storage_account.demo_storage_account.name
  storage_container_name = "$web"
  type                   = "Block"
  content_type           = "text/html"
  source                 = "index.html"
}

resource "local_file" "index_html_azure" {
  content  = templatefile("${path.module}/../skins/${var.skin}.html.tmpl", { orgname = var.orgname, what_to_say = replace(var.what_to_say, " ", "%20") })
  filename = "${path.module}/index.html"
}
