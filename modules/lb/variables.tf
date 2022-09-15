variable "lb_pub_ip_name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "lb_sku" {
  type = string
}
variable "pub_ip_sku" {
  type = string
}
variable "lb_name" {
  type =string
}
variable "lb_front_ip_name" {
  type = string
}
variable "lb_nat_pool_name" {
  type = string
}
variable "lb_nat_protocol" {
  type = string
}
variable "lb_nat_port_start" {
  type = number
}
variable "lb_nat_port_end" {
  type = number
}
variable "lb_nat_backend_port" {
  type = number
}
variable "lb_nat_front_config_name" {
  type = string
}
variable "lb_backend_pool_name" {
  type = string
}
variable "lb_rule_name" {
  type = string
}
variable "lb_rule_protocol" {
  type = string
}
variable "lb_rule_front_port" {
  type = number
}
variable "lb_rule_back_port" {
  type = number
}
variable "lb_rule_front_config_name" {
  type = string
}
variable "dns_label" {
  type = string
}
