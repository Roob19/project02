variable "bastion_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "bastion_pub_ip_allocation_method" {
  type = string
}
variable "vnet" {
  type = string
}
variable "bastion_address_prefixes" {
  type = list(string)
}
variable "pub_ip_sku" {
  type = string
}