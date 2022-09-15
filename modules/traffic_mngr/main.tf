resource "azurerm_traffic_manager_profile" "main_traffic_mngr" {
  name = var.traffic_mngr_name
  resource_group_name = var.rg_name
  traffic_routing_method = var.route_method
  dns_config {
    relative_name = var.dns_config_name
    ttl = var.ttl
  }
  monitor_config {
    protocol = upper(var.monitor_protocol)
    port = var.monitor_port_num
    path = var.monitor_path
    interval_in_seconds = var.interval_secs
    timeout_in_seconds = var.timeout_secs
    tolerated_number_of_failures = var.tolerated_num_of_fails
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_mngr_enpoint_a" {
  name = var.endpoint_a
#   resource_group_name = var.rg_name
    profile_id = azurerm_traffic_manager_profile.main_traffic_mngr.id
#   profile_name = azurerm_traffic_manager_profile.main_traffic_mngr.name
#   type = var.type_endpoint_a
#   target = var.dns_label_endpoint_a
  target_resource_id = var.id_of_targeted_resource_a
  weight = var.weight_of_endpoint_a
}

resource "azurerm_traffic_manager_azure_endpoint" "traffic_mngr_enpoint_b" {
  name = var.endpoint_b
#   resource_group_name = var.rg_name
  profile_id = azurerm_traffic_manager_profile.main_traffic_mngr.id
#   profile_name = azurerm_traffic_manager_profile.main_traffic_mngr.name
#   type = var.type_endpoint_b
#   target = var.dns_label_endpoint_b
  target_resource_id = var.id_of_targeted_resource_b
  weight = var.weight_of_endpoint_b
}
