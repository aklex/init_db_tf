locals {
  env = "test"
}

data "azurerm_resource_group" "this" {
  name     = "initdb"
}

resource "azurerm_mssql_server" "this" {
  name                         = "test-server78"
  resource_group_name          = data.azurerm_resource_group.this.name
  location                     = data.azurerm_resource_group.this.location
  version                      = "12.0"
  administrator_login          = "azureadmin"
  administrator_login_password = var.DB_ADMIN_PASSWORD
  minimum_tls_version          = "1.2"

  azuread_administrator {
    login_username = "db-admins"
    object_id      = "9f76ff68-d657-4629-a39c-ef63afb26b33"
  }

  tags = {
    environment = local.env
  }
}


resource "azurerm_mssql_database" "this" {
  name           = "testinit-db"
  server_id      = azurerm_mssql_server.this.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice"
  max_size_gb    = 4
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    environment = local.env
  }
}