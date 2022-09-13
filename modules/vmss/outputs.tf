output "linux_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.linux_vmss.id
}

output "linux_vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.linux_vmss.name
}

output "linux_vmss_subnet_id" {
  value = azurerm_subnet.vmss_subnet.id
}
