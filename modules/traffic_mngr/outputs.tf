output "main_traffic_mngr_id" {
  value = azurerm_traffic_manager_profile.main_traffic_mngr.id
}
output "main_traffic_mngr_name" {
  value = azurerm_traffic_manager_profile.main_traffic_mngr.name
}

output "traffic_mngr_endpoint_a_id" {
  value = azurerm_traffic_manager_azure_endpoint.traffic_mngr_enpoint_a.id
}
output "traffic_mngr_endpoint_a_name" {
  value = azurerm_traffic_manager_azure_endpoint.traffic_mngr_enpoint_a.name
}

output "traffic_mngr_endpoint_b_id" {
  value = azurerm_traffic_manager_azure_endpoint.traffic_mngr_enpoint_b.id
}
output "traffic_mngr_endpoint_b_name" {
  value = azurerm_traffic_manager_azure_endpoint.traffic_mngr_enpoint_b.name
}
