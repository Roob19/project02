variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "vnet" {
  type = string
}
variable "subnet_address_prefixes_front" {
  type = list(string)
}
variable "subnet_address_prefixes_back" {
  type = list(string)
}
variable "pub_ip_allocation" {
  type = string
}