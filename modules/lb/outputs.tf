output "lb_pub_ip_id" {
  value = azurerm_public_ip.lb_pub_ip.id
}

output "load_balancer_id" {
  value = azurerm_lb.load_balancer.id
}

output "lb_backend_pool_id" {
  value = azurerm_lb_backend_address_pool.lb_backend_pool.id
}

output "lb_nat_pool_id" {
  value = azurerm_lb_nat_pool.lb_nat_pool.id
}
