variable "traffic_mngr_name" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "route_method" {
  type = string
}
variable "dns_config_name" {
  type = string
}
variable "ttl" {
  type = number
}
variable "monitor_protocol" {
  type = string
}
variable "monitor_port_num" {
  type = number
}
variable "monitor_path" {
  type = string
}
variable "interval_secs" {
  type = number
}
variable "timeout_secs" {
  type = number
}
variable "tolerated_num_of_fails" {
  type = number
}

variable "endpoint_a" {
  type = string
}
# variable "type_endpoint_a" {
#   type = string
# }
# variable "dns_label_endpoint_a" {
#   type = string
# }
# variable "dns_label_endpoint_b" {
#   type = string
# }
variable "id_of_targeted_resource_a" {
  type = string
}
variable "weight_of_endpoint_a" {
  type = number
}

variable "endpoint_b" {
  type = string
}
# variable "type_endpoint_b" {
#   type = string
# }
variable "id_of_targeted_resource_b" {
  type = string
}
variable "weight_of_endpoint_b" {
  type = number
}
