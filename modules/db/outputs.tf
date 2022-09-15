output "mssql_server_admin_login_primary" {
  value = azurerm_mssql_server.mysql_server_primary.administrator_login
}
output "mssql_server_admin_login_secondary" {
  value = azurerm_mssql_server.mysql_server_secondary.administrator_login
}
output "mssql_server_admin_pass_primary" {
  value = azurerm_mssql_server.mysql_server_primary.administrator_login_password
}
output "mssql_server_admin_pass_secondary" {
  value = azurerm_mssql_server.mysql_server_secondary.administrator_login_password
}
output "mssql_sever_name_primary" {
  value = azurerm_mssql_server.mysql_server_primary.name
}
output "mssql_sever_name_secondary" {
  value = azurerm_mssql_server.mysql_server_secondary.name
}