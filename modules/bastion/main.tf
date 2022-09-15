resource "azurerm_bastion_host" "bastion_host" {
  name = var.bastion_name
  location = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name = "${var.bastion_name}_ip_config"
    subnet_id = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pub_ip.id
  }
}

resource "azurerm_public_ip" "bastion_pub_ip" {
  name = "${var.bastion_name}_pub_ip"
  location = var.rg_location
  sku = var.pub_ip_sku
  resource_group_name = var.rg_name
  allocation_method = var.bastion_pub_ip_allocation_method
}

resource "azurerm_subnet" "bastion_subnet" {
  name = "AzureBastionSubnet"
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet
  address_prefixes = var.bastion_address_prefixes
}