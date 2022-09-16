resource "azurerm_subnet" "app_gate_subnet_frontend" {
  name                 = "${var.rg_name}_front_gate"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet_address_prefixes_front
}

resource "azurerm_subnet" "app_gate_subnet_backend" {
  name                 = "${var.rg_name}_back_gate"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = var.subnet_address_prefixes_back
}

resource "azurerm_public_ip" "app_gate_pub_ip" {
  name                = "${var.rg_name}_app_gate_pub_ip"
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = var.pub_ip_allocation
}

#&nbsp;since these variables are re-used - a locals block makes this more maintainable
locals {
  backend_address_pool_name      = "${var.vnet}-beap"
  frontend_port_name             = "${var.vnet}-feport"
  frontend_ip_configuration_name = "${var.vnet}-feip"
  http_setting_name              = "${var.vnet}-be-htst"
  listener_name                  = "${var.vnet}-httplstn"
  request_routing_rule_name      = "${var.vnet}-rqrt"
  redirect_configuration_name    = "${var.vnet}-rdrcfg"
}

resource "azurerm_application_gateway" "app_gateway" {
  name                = "${var.rg_name}-appgateway"
  resource_group_name = var.rg_name
  location            = var.rg_location

  sku {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = azurerm_subnet.app_gate_subnet_frontend.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.app_gate_pub_ip.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    path                  = "/path1/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }
}