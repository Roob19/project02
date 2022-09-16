variable "my_sql_server_name" {
  type = string
}
variable "rg_location" {
  type = string
}
variable "rg_name" {
  type = string
}
variable "sql_admin_un" {
  type = string
}
variable "sql_admin_pass" {
  type = string
}
variable "sql_server_sku" {
  type = string
}
variable "sql_storage_mb" {
  type = number
}
variable "mysql_server_version" {
  type = string
}

/*
variable "sql_domain_name" {
  type = string
}
variable "sql_replication_role" {
  type = string
}
variable "sql_master_server_id" {
  type = string
}
variable "sql_replica_capacity" {
  type = number
}
*/

variable "sql_server_auto_grow" {
  type = bool
}
variable "sql_backup_retention_days" {
  type = number
}
variable "sql_create_mode" {
  type = string
}
variable "sql_source_server_id" {
  type = string
}
variable "sql_geo_redundant_backup_enabled" {
  type = bool
}
variable "sql_infrastructure_encryption_enabled" {
  type = bool
}
variable "sql_public_network_access_enabled" {
  type = bool
}
variable "sql_ssl_enforcement_enabled" {
  type = bool
}
variable "sql_ssl_minimal_tls_version_enforced" {
  type = string
}
variable "sql_db_name" {
  type = string
}
variable "db_charset" {
  type = string
}
variable "db_collation" {
  type = string
}