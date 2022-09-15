resource "azurerm_public_ip" "lb_pub_ip" {
  name = var.lb_pub_ip_name
  resource_group_name = var.rg_name
  location = var.rg_location
  sku = var.pub_ip_sku
  allocation_method = "Static"
  domain_name_label = var.dns_label
}

resource "azurerm_lb" "load_balancer" {
  name = var.lb_name
  resource_group_name = var.rg_name
  location = var.rg_location
  sku = var.lb_sku
  
  frontend_ip_configuration {
    name = var.lb_front_ip_name
    public_ip_address_id = azurerm_public_ip.lb_pub_ip.id
  }
}

resource "azurerm_lb_nat_pool" "lb_nat_pool" {
  name = var.lb_nat_pool_name
  resource_group_name = var.rg_name
  loadbalancer_id = azurerm_lb.load_balancer.id
  protocol = var.lb_nat_protocol
  frontend_port_start = var.lb_nat_port_start
  frontend_port_end = var.lb_nat_port_end
  backend_port = var.lb_nat_backend_port
  frontend_ip_configuration_name = var.lb_nat_front_config_name
}

resource "azurerm_lb_backend_address_pool" "lb_backend_pool" {
  name = var.lb_backend_pool_name
  loadbalancer_id = azurerm_lb.load_balancer.id
}

resource "azurerm_lb_rule" "lb_rule" {
  name = var.lb_rule_name
  loadbalancer_id = azurerm_lb.load_balancer.id
  protocol = var.lb_rule_protocol
  frontend_port = var.lb_rule_front_port
  backend_port = var.lb_rule_back_port
  frontend_ip_configuration_name = var.lb_rule_front_config_name
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.lb_backend_pool.id ]
}
