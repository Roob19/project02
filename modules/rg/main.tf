terraform {
  required_version = ">=1.2"
}

resource "azurerm_resource_group" "main_rg" {
  name     = upper(var.rg_name)
  location = var.location
}
