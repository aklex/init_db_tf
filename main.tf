locals {
  env = "test"
  sql_script = ".\\initdb.sql"
  init_ps_script = ".\\initdb.ps1"
}

data "azurerm_resource_group" "this" {
  name     = "init-db"
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

resource "azurerm_mssql_firewall_rule" "this" {
  name                = "MyNetwork"
  server_id           = azurerm_mssql_server.this.id
  start_ip_address    = "185.102.185.1"
  end_ip_address      = "185.102.185.254"
  depends_on = [azurerm_mssql_server.this]
}


resource "azurerm_mssql_database" "this" {
  name           = "testinit-db"
  server_id      = azurerm_mssql_server.this.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "BasePrice"
  max_size_gb    = 2
  read_scale     = false
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    environment = local.env
  }
  depends_on = [azurerm_mssql_server.this]
}

resource "null_resource" "this" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "Invoke-Sqlcmd -ServerInstance ${azurerm_mssql_server.this.fully_qualified_domain_name} -Database ${azurerm_mssql_database.this.name} -Username ${azurerm_mssql_server.this.administrator_login} -Password ${var.DB_ADMIN_PASSWORD} -ConnectionTimeout 5 -InputFile ${local.sql_script} -Verbose 4>&1 | Out-String"
    #command = "echo ${var.DB_ADMIN_PASSWORD}"
    interpreter = ["PowerShell", "-Command"]
  }
  depends_on = [azurerm_mssql_server.this, azurerm_mssql_database.this]
}