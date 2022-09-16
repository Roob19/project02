resource "azurerm_mysql_server" "mysql_server" {
  name                = var.my_sql_server_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  administrator_login          = var.sql_admin_un
  administrator_login_password = var.sql_admin_pass

  sku_name   = var.sql_server_sku
  storage_mb = var.sql_storage_mb
  version    = var.mysql_server_version
  
#   fully_qualified_domain_name = var.sql_domain_name
#   replication_role = var.sql_replication_role
#   master_server_id = var.sql_master_server_id
#   replica_capacity = var.sql_replica_capacity

  auto_grow_enabled                 = var.sql_server_auto_grow
  backup_retention_days             = var.sql_backup_retention_days
  create_mode = var.sql_create_mode
  creation_source_server_id = var.sql_create_mode == "Replica" ? var.sql_source_server_id : null
  geo_redundant_backup_enabled      = var.sql_geo_redundant_backup_enabled
  infrastructure_encryption_enabled = var.sql_infrastructure_encryption_enabled
  public_network_access_enabled     = var.sql_public_network_access_enabled
  ssl_enforcement_enabled           = var.sql_ssl_enforcement_enabled
  ssl_minimal_tls_version_enforced  = var.sql_ssl_minimal_tls_version_enforced
}

resource "azurerm_mysql_database" "mysql_db" {
  name                = var.sql_db_name
  resource_group_name = azurerm_mysql_server.mysql_server.resource_group_name
  server_name         = azurerm_mysql_server.mysql_server.name
  charset             = var.db_charset
  collation           = var.db_collation
}
