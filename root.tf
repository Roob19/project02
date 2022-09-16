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

###============================== EAST ===============================


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

module "bastion_east" {
  source                           = "./modules/bastion"
  bastion_name                     = "t2_bastion_east"
  rg_location                      = module.rg_east.main_rg.location
  rg_name                          = module.rg_east.main_rg.name
  pub_ip_sku                       = "Standard"
  bastion_pub_ip_allocation_method = "Static"
  vnet                             = module.vnet_east.vnet_name
  bastion_address_prefixes         = ["172.16.3.0/24"]
}

module "load_balancer_east" {
  source                    = "./modules/lb"
  lb_pub_ip_name            = "vmss_lb_pub_ip_east"
  rg_name                   = module.rg_east.main_rg.name
  rg_location               = module.rg_east.main_rg.location
  lb_name                   = "vmss_lb_east"
  pub_ip_sku                = "Standard"
  lb_sku                    = "Standard"
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

module "app_gate_east" {
  source                        = "./modules/app_gateway"
  rg_name                       = module.rg_east.main_rg.name
  rg_location                   = module.rg_east.main_rg.location
  vnet                          = module.vnet_east.vnet_name
  subnet_address_prefixes_front = ["172.16.5.0/24"]
  subnet_address_prefixes_back  = ["172.24.5.0/24"]
  pub_ip_allocation             = "Dynamic"
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

  #   vmss_custom_data             = file("t3_custom_data.sh")
  #   vmss_custom_data             = file("t1_custom_data.sh")
  vmss_custom_data = file("t2_custom_data.sh")

  nic_name                 = "t2_vmss_nic_east"
  lb_backend_ids           = [module.load_balancer_east.lb_backend_pool_id]
  lb_inbound_nat_rules_ids = [module.load_balancer_east.lb_nat_pool_id]
  /*
  sql_admin_un             = module.sql_server_and_dbs.mssql_server_admin_login_primary
  sql_admin_pass           = module.sql_server_and_dbs.mssql_server_admin_pass_primary
  sql_server_name          = module.sql_server_and_dbs.mssql_sever_name_primary
  */
  sql_admin_un    = var.sql_admin_un
  sql_admin_pass  = var.sql_admin_pass
  sql_server_name = module.mysql_east.mysql_server_name
}

module "mysql_east" {
  source               = "./modules/mysql"
  my_sql_server_name   = "sql-server-east"
  rg_location          = module.rg_east.main_rg.location
  rg_name              = module.rg_east.main_rg.name
  sql_admin_un         = var.sql_admin_un
  sql_admin_pass       = var.sql_admin_pass
  sql_server_sku       = "GP_Gen5_2"
  sql_storage_mb       = 5120
  mysql_server_version = "5.7"
  #   sql_domain_name = ""
  #   sql_replication_role                  = "Master"
  #   sql_master_server_id                  = ""
  #   sql_replica_capacity                  = 5
  sql_server_auto_grow                  = true
  sql_backup_retention_days             = 7
  sql_create_mode                       = null
  sql_source_server_id                  = null
  sql_geo_redundant_backup_enabled      = false
  sql_infrastructure_encryption_enabled = false
  sql_public_network_access_enabled     = true
  sql_ssl_enforcement_enabled           = false
  sql_ssl_minimal_tls_version_enforced  = "TLSEnforcementDisabled"
  sql_db_name                           = "mysql-db-east"
  db_charset                            = "utf8"
  db_collation                          = "utf8_unicode_ci"
}


###=============================== WEST ===============================


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

module "bastion_west" {
  source                           = "./modules/bastion"
  bastion_name                     = "t2_bastion_west"
  rg_location                      = module.rg_west.main_rg.location
  rg_name                          = module.rg_west.main_rg.name
  pub_ip_sku                       = "Standard"
  bastion_pub_ip_allocation_method = "Static"
  vnet                             = module.vnet_west.vnet_name
  bastion_address_prefixes         = ["192.16.3.0/24"]
}

module "load_balancer_west" {
  source                    = "./modules/lb"
  lb_pub_ip_name            = "lb_pub_ip_west"
  rg_name                   = module.rg_west.main_rg.name
  rg_location               = module.rg_west.main_rg.location
  pub_ip_sku                = "Standard"
  lb_sku                    = "Standard"
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

module "app_gate_west" {
  source                        = "./modules/app_gateway"
  rg_name                       = module.rg_west.main_rg.name
  rg_location                   = module.rg_west.main_rg.location
  vnet                          = module.vnet_west.vnet_name
  subnet_address_prefixes_front = ["192.16.5.0/24"]
  subnet_address_prefixes_back  = ["192.24.5.0/24"]
  pub_ip_allocation             = "Dynamic"
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

  vmss_custom_data = null

  nic_name                 = "t2_vmss_nic_west"
  lb_backend_ids           = [module.load_balancer_west.lb_backend_pool_id]
  lb_inbound_nat_rules_ids = [module.load_balancer_west.lb_nat_pool_id]
  /*
  sql_admin_un             = module.sql_server_and_dbs.mssql_server_admin_login_secondary
  sql_admin_pass           = module.sql_server_and_dbs.mssql_server_admin_pass_secondary
  sql_server_name          = module.sql_server_and_dbs.mssql_sever_name_secondary
  */
  sql_admin_un    = var.sql_admin_un
  sql_admin_pass  = var.sql_admin_pass
  sql_server_name = module.mysql_west.mysql_server_name
}

module "mysql_west" {
  source               = "./modules/mysql"
  my_sql_server_name   = "sql-server-west"
  rg_location          = module.rg_west.main_rg.location
  rg_name              = module.rg_west.main_rg.name
  sql_admin_un         = var.sql_admin_un
  sql_admin_pass       = var.sql_admin_pass
  sql_server_sku       = "GP_Gen5_2"
  sql_storage_mb       = 5120
  mysql_server_version = "5.7"
  #   sql_domain_name = ""
  #   sql_replication_role                  = "Replica"
  #   sql_master_server_id                  = module.mysql_east.mysql_server_id
  #   sql_replica_capacity                  = 0
  sql_server_auto_grow                  = true
  sql_backup_retention_days             = 7
  sql_create_mode                       = "Replica"
  sql_source_server_id                  = module.mysql_east.mysql_server_id
  sql_geo_redundant_backup_enabled      = false
  sql_infrastructure_encryption_enabled = false
  sql_public_network_access_enabled     = true
  sql_ssl_enforcement_enabled           = false
  sql_ssl_minimal_tls_version_enforced  = "TLSEnforcementDisabled"
  sql_db_name                           = "mysql-db-west"
  db_charset                            = "utf8"
  db_collation                          = "utf8_unicode_ci"
}



###============================= CENTRAL ===============================


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
module "traffic_manager_app_gate" {
  source                 = "./modules/traffic_mngr"
  traffic_mngr_name      = "t2trafficmanagerappgate"
  rg_name                = module.rg_cent.main_rg.name
  route_method           = "Weighted"
  dns_config_name        = "t2trafficmngrdnsconfigappgate" # t2_traffic_mngr_dns_config.trafficmanager.net is invalid
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
  #   id_of_targeted_resource_a = module.load_balancer_east.lb_pub_ip_id
  id_of_targeted_resource_a = module.app_gate_east.app_gate_pub_ip_id
  # module.load_balancer_east.load_balancer_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_EAST/providers/Microsoft.Network/loadBalancers/vmss_lb_east"
  weight_of_endpoint_a = 1

  endpoint_b = "t2_endpoint_b"
  #   type_endpoint_b           = "azureEndpoints" # azureEndpoints externalEndpoints nestedEndpoints
  #   dns_label_endpoint_b      = "t2dnslabelwest.westus.cloudapp.azure.com"
  #   id_of_targeted_resource_b = module.load_balancer_west.lb_pub_ip_id
  id_of_targeted_resource_b = module.app_gate_west.app_gate_pub_ip_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_WEST/providers/Microsoft.Network/loadBalancers/lb_west"
  weight_of_endpoint_b = 2
}

module "traffic_manager_lb" {
  source                 = "./modules/traffic_mngr"
  traffic_mngr_name      = "t2trafficmanagerlb"
  rg_name                = module.rg_cent.main_rg.name
  route_method           = "Weighted"
  dns_config_name        = "t2trafficmngrdnsconfiglb" # t2_traffic_mngr_dns_config.trafficmanager.net is invalid
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
  #   id_of_targeted_resource_a = module.app_gate_east.app_gate_pub_ip_id
  # module.load_balancer_east.load_balancer_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_EAST/providers/Microsoft.Network/loadBalancers/vmss_lb_east"
  weight_of_endpoint_a = 3

  endpoint_b = "t2_endpoint_b"
  #   type_endpoint_b           = "azureEndpoints" # azureEndpoints externalEndpoints nestedEndpoints
  #   dns_label_endpoint_b      = "t2dnslabelwest.westus.cloudapp.azure.com"
  id_of_targeted_resource_b = module.load_balancer_west.lb_pub_ip_id
  #   id_of_targeted_resource_b = module.app_gate_west.app_gate_pub_ip_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_WEST/providers/Microsoft.Network/loadBalancers/lb_west"
  weight_of_endpoint_b = 4
}

module "traffic_manager_kay" {
  source                 = "./modules/traffic_mngr"
  traffic_mngr_name      = "t2trafficmanagerkay"
  rg_name                = module.rg_cent.main_rg.name
  route_method           = "Weighted"
  dns_config_name        = "t2trafficmngrdnsconfigkay" # t2_traffic_mngr_dns_config.trafficmanager.net is invalid
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
  id_of_targeted_resource_a = "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/Team2Proj2_rg1/providers/Microsoft.Network/loadBalancers/vmss-lb"
  #   id_of_targeted_resource_a = module.load_balancer_east.lb_pub_ip_id
  #   id_of_targeted_resource_a = module.app_gate_east.app_gate_pub_ip_id
  # module.load_balancer_east.load_balancer_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_EAST/providers/Microsoft.Network/loadBalancers/vmss_lb_east"
  weight_of_endpoint_a = 5

  endpoint_b = "t2_endpoint_b"
  #   type_endpoint_b           = "azureEndpoints" # azureEndpoints externalEndpoints nestedEndpoints
  #   dns_label_endpoint_b      = "t2dnslabelwest.westus.cloudapp.azure.com"
  id_of_targeted_resource_b = "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/Team2Proj2_rg2/providers/Microsoft.Network/loadBalancers/vmss-lb2"
  #   id_of_targeted_resource_b = module.load_balancer_west.lb_pub_ip_id
  #   id_of_targeted_resource_b = module.app_gate_west.app_gate_pub_ip_id
  # "/subscriptions/65684f2a-01e2-443f-8763-39047d2a965b/resourceGroups/T2_RG_WEST/providers/Microsoft.Network/loadBalancers/lb_west"
  weight_of_endpoint_b = 6
}

/*
module "sql_server_and_dbs" {
  source                                     = "./modules/mssql"
  primary_sql_server_name                    = "t2-sql-server-primary"
  secondary_sql_server_name                  = "t2-sql-server-secondary"
  primary_rg_location                        = module.rg_east.main_rg.location
  primary_rg_name                            = module.rg_east.main_rg.name
  secondary_rg_location                      = module.rg_west.main_rg.location
  secondary_rg_name                          = module.rg_west.main_rg.name
  sql_admin_username                         = var.sql_admin_un
  sql_admin_password                         = var.sql_admin_pass
  primary_sql_server_version                 = "12.0"
  secondary_sql_server_version               = "12.0"
  primary_sql_server_public_access           = false
  sql_db_name                                = "t2_database"
  sql_db_collation                           = "SQL_Latin1_General_CP1_CI_AS"
  sql_db_max_size_gb                         = "200"
  sql_failover_group_name                    = "t2-failover"
  sql_failover_endpoint_policy_mode          = "Automatic"
  sql_failover_endpoint_policy_grace_minutes = 60
}
*/