/*
variable "prefix" {
  type        = string
  description = "Initials as Prefix"
}
*/
variable "rg_name" {
  type = string
  description = "Main Resource Group name"
}

variable "rg_location" {
  type        = string
  description = "Azure Region/Location"
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
  description = "List of IP addresses for vnet"
}
/*
variable "default_tags" {
  type        = map(string)
  description = "Map of Tags"
}
*/
variable "subnet_name" {
  type = string
  description = "Name of main subnet"
}

variable "subnet_address_prefixes" {
  type = list(string)
  description = "List of address prefixes"
}