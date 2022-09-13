resource "azurerm_subnet" "vmss_subnet" {
  name = var.vmss_subnet_name
  resource_group_name = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes = var.vmss_subnet_address_prefixes
}

resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  name = var.vmss_name
  resource_group_name = var.rg_name
  location = var.rg_location
  sku = var.vmss_sku
  instances = var.vmss_instances
  admin_username = var.vmss_admin
  admin_password = var.vmss_pass
  disable_password_authentication = var.vmss_disable_pass_auth

#   custom_data = base64encode(var.vmss_custom_data)
  
#   delete_os_disk_on_termination = var.delete_os_disk_on_termination
#   delete_data_disks_on_termination = var.delete_data_disks_on_termination
  
  source_image_reference {
    publisher = var.vm_image_publisher
    offer = var.vm_image_offer
    sku = var.vm_image_sku
    version = var.vm_image_version
  }

  os_disk {
    storage_account_type = var.disk_storage_type
    caching = var.disk_caching
  }

  network_interface {
    name = var.nic_name
    primary = true
    ip_configuration {
        name = "internal"
        primary = true
        subnet_id = azurerm_subnet.vmss_subnet.id
        load_balancer_backend_address_pool_ids = var.lb_backend_ids
        load_balancer_inbound_nat_rules_ids = var.lb_inbound_nat_rules_ids
    }
  }
}
