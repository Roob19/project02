resource "azurerm_virtual_network" "main_vnet" {
  name                = upper("${var.vnet_name}")
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.vnet_address_space
}

resource "azurerm_subnet" "main_subnet" {
  name                 = upper("${var.subnet_name}")
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.main_vnet.name
  address_prefixes     = var.subnet_address_prefixes
}
