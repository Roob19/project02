/*
module "rg_regions" {
  for_each = var.azure_regions
  source   = "./modules/rg"
  rg_name  = "t2_rg_${each.key}"
  location = each.value
}

module "vnet_regions" {
  for_each = var.azure_regions
  source                  = "./modules/vnet"
  rg_name                 = "t2_rg_${each.key}"
  rg_location             = each.value
  vnet_name               = "t2_vnet_${each.key}"
  vnet_address_space      = ["${index(var.ip_class, each.value)}.8.0.0/13", "${index(var.ip_class, each.value)}.16.0.0/13"]
  subnet_name             = "t2_subnet_${each.key}"
  subnet_address_prefixes = ["${index(var.ip_class, each.value)}.8.1.0/24"]
}
*/

### EAST
module "rg_east" {
  source   = "./modules/rg"
  rg_name  = "t2_rg_east"
  location = "eastus"
}

module "vnet_east" {
  source                  = "./modules/vnet"
  rg_name                 = module.rg_east.main_rg.name
  rg_location             = module.rg_east.main_rg.location
  vnet_name               = "t2_vnet_east"
  vnet_address_space      = ["172.8.0.0/13", "172.16.0.0/13", "172.24.0.0/13"]
  subnet_name             = "t2_subnet_east"
  subnet_address_prefixes = ["172.8.1.0/24"]
}

module "load_balancer_east" {
  source                    = "./modules/lb"
  lb_pub_ip_name            = "vmss_lb_pub_ip_east"
  rg_name                   = module.rg_east.main_rg.name
  rg_location               = module.rg_east.main_rg.location
  lb_name                   = "vmss_lb_east"
  lb_front_ip_name          = "lb_frontend_ip_east"
  dns_label                 = "t2-pubip-dns-east"
  lb_nat_pool_name          = "lb_ssh_nat_east"
  lb_nat_protocol           = "Tcp"
  lb_nat_port_start         = 50005
  lb_nat_port_end           = 50055
  lb_nat_backend_port       = 22
  lb_nat_front_config_name  = "lb_frontend_ip_east"
  lb_backend_pool_name      = "lb_backend_addresses_east"
  lb_rule_name              = "lb_http_rule_east"
  lb_rule_protocol          = "Tcp"
  lb_rule_front_port        = 80
  lb_rule_back_port         = 80
  lb_rule_front_config_name = "lb_frontend_ip_east"
}

module "vmss_east" {
  source                       = "./modules/vmss"
  vmss_subnet_name             = "scale_set_east"
  vnet_name                    = module.vnet_east.vnet_name
  vmss_subnet_address_prefixes = ["172.16.1.0/24"]
  vmss_name                    = "scale-set-east"
  rg_name                      = module.rg_east.main_rg.name
  rg_location                  = module.rg_east.main_rg.location
  vmss_sku                     = "Standard_B2s"
  vmss_instances               = 3
  vmss_admin                   = var.admin_username
  vmss_pass                    = var.admin_password
  vmss_disable_pass_auth       = false
  vm_image_publisher           = "Canonical"
  vm_image_offer               = "0001-com-ubuntu-server-focal"
  vm_image_sku                 = "20_04-lts-gen2"
  vm_image_version             = "latest"
  disk_storage_type            = "Standard_LRS"
  disk_caching                 = "ReadWrite"
  #   vmss_custom_data = 
  #   delete_os_disk_on_termination    = false
  #   delete_data_disks_on_termination = false
  nic_name                 = "t2_vmss_nic_east"
  lb_backend_ids           = [module.load_balancer_east.lb_backend_pool_id]
  lb_inbound_nat_rules_ids = [module.load_balancer_east.lb_nat_pool_id]
}

### WEST
module "rg_west" {
  source   = "./modules/rg"
  rg_name  = "t2_rg_west"
  location = "westus"
}

module "vnet_west" {
  source                  = "./modules/vnet"
  rg_name                 = module.rg_west.main_rg.name
  rg_location             = module.rg_west.main_rg.location
  vnet_name               = "t2_vnet_west"
  vnet_address_space      = ["192.8.0.0/13", "192.16.0.0/13", "192.24.0.0/13"]
  subnet_name             = "t2_subnet_west"
  subnet_address_prefixes = ["192.8.1.0/24"]
}

module "load_balancer_west" {
  source                    = "./modules/lb"
  lb_pub_ip_name            = "lb_pub_ip_west"
  rg_name                   = module.rg_west.main_rg.name
  rg_location               = module.rg_west.main_rg.location
  lb_name                   = "lb_west"
  lb_front_ip_name          = "lb_frontend_ip_west"
  dns_label                 = "t2-pubip-dns-west"
  lb_nat_pool_name          = "lb_nat_ssh_west"
  lb_nat_protocol           = "Tcp"
  lb_nat_port_start         = 50005
  lb_nat_port_end           = 50555
  lb_nat_backend_port       = 22
  lb_nat_front_config_name  = "lb_frontend_ip_west"
  lb_backend_pool_name      = "lb_backend_addresses_west"
  lb_rule_name              = "lb_http_rule_west"
  lb_rule_protocol          = "Tcp"
  lb_rule_front_port        = 80
  lb_rule_back_port         = 80
  lb_rule_front_config_name = "lb_frontend_ip_west"
}

module "vmss_west" {
  source                       = "./modules/vmss"
  vmss_subnet_name             = "scale_set_west"
  vnet_name                    = module.vnet_west.vnet_name
  vmss_subnet_address_prefixes = ["192.16.1.0/24"]
  vmss_name                    = "scale-set-west"
  rg_name                      = module.rg_west.main_rg.name
  rg_location                  = module.rg_west.main_rg.location
  vmss_sku                     = "Standard_B2s"
  vmss_instances               = 3
  vmss_admin                   = var.admin_username
  vmss_pass                    = var.admin_password
  vmss_disable_pass_auth       = false
  vm_image_publisher           = "Canonical"
  vm_image_offer               = "0001-com-ubuntu-server-focal"
  vm_image_sku                 = "20_04-lts-gen2"
  vm_image_version             = "latest"
  disk_storage_type            = "Standard_LRS"
  disk_caching                 = "ReadWrite"
  #   vmss_custom_data = 
  #   delete_os_disk_on_termination    = false
  #   delete_data_disks_on_termination = false
  nic_name                 = "t2_vmss_nic_west"
  lb_backend_ids           = [module.load_balancer_west.lb_backend_pool_id]
  lb_inbound_nat_rules_ids = [module.load_balancer_west.lb_nat_pool_id]
}


### CENTRAL
module "rg_cent" {
  source   = "./modules/rg"
  rg_name  = "t2_rg_cent"
  location = "centralus"
}
/*
module "vnet_cent" {
  source                  = "./modules/vnet"
  rg_name                 = module.rg_cent.main_rg.name
  rg_location             = module.rg_cent.main_rg.location
  vnet_name               = "t2_vnet_cent"
  vnet_address_space      = ["10.8.0.0/13"]
  subnet_name             = "t2_subnet_cent"
  subnet_address_prefixes = ["10.8.1.0/24"]
}
*/
module "traffic_manager" {
  source            = "./modules/traffic_mngr"
  traffic_mngr_name = "t2trafficmanager"
  rg_name           = module.rg_cent.main_rg.name
  route_method      = "Weighted"
  dns_config_name   = "t2trafficmngrdnsconfig"
  ### t2_traffic_mngr_dns_config.trafficmanager.net is invalid
  ttl                    = 100
  monitor_protocol       = "HTTP"
  monitor_port_num       = 80
  monitor_path           = "/"
  interval_secs          = 30
  timeout_secs           = 9
  tolerated_num_of_fails = 3

  endpoint_a = "t2_endpoint_a"
  #   type_endpoint_a           = "azureEndpoints" # azureEndpoints externalEndpoints nestedEndpoints
  #   dns_label_endpoint_a      = "t2dnslabeleast.eastus.cloudapp.azure.com"
  id_of_targeted_resource_a = module.load_balancer_east.lb_pub_ip_id
  # module.load_balancer_east.load_balancer_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_EAST/providers/Microsoft.Network/loadBalancers/vmss_lb_east"
  weight_of_endpoint_a = 10

  endpoint_b = "t2_endpoint_b"
  #   type_endpoint_b           = "azureEndpoints" # azureEndpoints externalEndpoints nestedEndpoints
  #   dns_label_endpoint_b      = "t2dnslabelwest.westus.cloudapp.azure.com"
  id_of_targeted_resource_b = module.load_balancer_west.lb_pub_ip_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_WEST/providers/Microsoft.Network/loadBalancers/lb_west"
  weight_of_endpoint_b = 9
}