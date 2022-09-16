resource "azurerm_mssql_server" "mssql_server_primary" {
  name                = var.primary_sql_server_name
  location            = var.primary_rg_location
  resource_group_name = var.primary_rg_name

  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password

  version = var.primary_sql_server_version
  public_network_access_enabled     = var.primary_sql_server_public_access
}

resource "azurerm_mssql_database" "mysql_db" {
  name                = var.sql_db_name
#resource_group_name = var.rg_name
  server_id           = azurerm_mssql_server.mssql_server_primary.id  
  collation           = var.sql_db_collation
  max_size_gb = var.sql_db_max_size_gb
}

resource "azurerm_mssql_server" "mysql_server_secondary" {
  name                = var.secondary_sql_server_name
  location            = var.secondary_rg_location
  resource_group_name = var.secondary_rg_name

  version = var.secondary_sql_server_version
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_failover_group" "sql_failover_group" {
  name        = var.sql_failover_group_name
#   resource_group_name = var.primary_rg_name
#   server_name = azurerm_mssql_server.mssql_server_primary.name
  server_id = azurerm_mssql_server.mssql_server_primary.id
  databases   = [
    azurerm_mssql_database.mysql_db.id
  ]

  partner_server {
    id = azurerm_mssql_server.mysql_server_secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = var.sql_failover_endpoint_policy_mode
    grace_minutes = var.sql_failover_endpoint_policy_grace_minutes
  }

  tags = {
    CreatedBy = "Kay"
  }
}
