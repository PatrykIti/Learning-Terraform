locals {
  resource_prefix     = "stor"
  resource_group_name = "rg-stor"
}

resource "azurerm_resource_group" "rg_stor" {
  name     = "${local.resource_prefix}-01"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "${local.resource_prefix}testpc01"
  location                 = var.location
  resource_group_name      = azurerm_resource_group.rg_stor.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = var.tags
}

resource "azurerm_storage_container" "st_container" {
  name                  = "${local.resource_prefix}test1"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}