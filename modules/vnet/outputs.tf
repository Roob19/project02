output "vnet_name" {
  value = azurerm_virtual_network.main_vnet.name
}

output "vnet_location" {
  value = azurerm_virtual_network.main_vnet.location
}

output "vnet_address_space" {
  value = azurerm_virtual_network.main_vnet.address_space
}

output "subnet_id" {
  value = azurerm_subnet.main_subnet.id
}

output "subnet_name" {
  value = azurerm_subnet.main_subnet.name
}

output "subnet_vnet_name" {
  value = azurerm_subnet.main_subnet.virtual_network_name
}

output "subnet_address_prefixes" {
  value = azurerm_subnet.main_subnet.address_prefixes
}
