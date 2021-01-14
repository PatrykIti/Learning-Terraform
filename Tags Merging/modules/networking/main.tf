locals {
  resource_prefix = "web"
}
resource "azurerm_resource_group" "web_rg" {
  name     = "${local.resource_prefix}-rg-01"
  location = var.location
  tags     = var.tags
}
resource "azurerm_virtual_network" "web_vnet" {
  name                = "${local.resource_prefix}-vnet-01"
  location            = var.location
  resource_group_name = azurerm_resource_group.web_rg.name
  address_space       = [var.vnet_address_space]
  tags                = var.tags
}
