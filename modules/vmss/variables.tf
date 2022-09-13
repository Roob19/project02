variable "vmss_subnet_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vmss_subnet_address_prefixes" {
  type = list(string)
}

variable "vmss_name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "vmss_sku" {
  type = string
}
variable "vmss_instances" {
  type = number
}
variable "vmss_admin" {
  type = string
}
variable "vmss_pass" {
  type = string
}
variable "vmss_disable_pass_auth" {
  type = bool
}
variable "vm_image_publisher" {
  type = string
}
variable "vm_image_offer" {
  type = string
}
variable "vm_image_sku" {
  type = string
}
variable "vm_image_version" {
  type = string
}
variable "disk_storage_type" {
  type = string
}
variable "disk_caching" {
  type = string
}
/*
variable "delete_os_disk_on_termination" {
  type = bool
}
variable "delete_data_disks_on_termination" {
  type = bool
}
*/
variable "nic_name" {
  type = string
}
# variable "subnet_id" {
#   type = string
# }
variable "lb_backend_ids" {
  type = list(string)
}
variable "lb_inbound_nat_rules_ids" {
  type = list(string)
}
# variable "vmss_custom_data" {
#   type = map
# }
