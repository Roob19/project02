variable "primary_sql_server_name" {
  type = string
}
variable "secondary_sql_server_name" {
  type = string
}
variable "primary_rg_location" {
  type = string
}
variable "primary_rg_name" {
  type = string
}
variable "secondary_rg_location" {
  type = string
}
variable "secondary_rg_name" {
  type = string
}
variable "sql_admin_username" {
  type = string
}
variable "sql_admin_password" {
  type = string
}
variable "primary_sql_server_version" {
  type = string
}
variable "secondary_sql_server_version" {
  type = string
}
variable "primary_sql_server_public_access" {
  type = bool
}
variable "sql_db_name" {
  type = string
}
variable "sql_db_collation" {
  type = string
}
variable "sql_db_max_size_gb" {
  type = string
}
variable "sql_failover_group_name" {
  type = string
}
variable "sql_failover_endpoint_policy_mode" {
  type = string
}
variable "sql_failover_endpoint_policy_grace_minutes" {
  type = number
}
