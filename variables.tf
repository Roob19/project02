variable "tenant_id" {
  type      = string
  sensitive = true
}

variable "subscription_id" {
  type      = string
  sensitive = true
}

variable "prefix" {
  type = string
}
/*
variable "rg_name" {
  type        = string
  description = "Resource Group Name"
  default     = "rad_tf_rg"
  sensitive   = false
}
*/
variable "default_tags" {
  type        = map(string)
  description = "tags for resources"
}

variable "storage_account_name" {
  type        = string
  description = "Storge where backend's are"
}

variable "container_name" {
  type        = string
  description = "Where TF states are"
}

variable "admin_username" {
  type      = string
  sensitive = true
}

variable "admin_password" {
  type      = string
  sensitive = true
}

variable "azure_regions" {
  type = map(string)
}

variable "ip_class" {
  type = map(string)
}