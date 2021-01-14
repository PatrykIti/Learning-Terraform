provider "azurerm" {
  version = "2.2.0"
  features {}
}

data "azurerm_subscription" "current" {}

locals {
  subscription_id     = data.azurerm_subscription.current.subscription_id
  tenant_id           = data.azurerm_subscription.current.tenant_id
  resource_group_name = "terra-rg"
  location            = "westus2"
  container           = "terra"
  key_vault_name      = "TerraVaultUdemy"

  tags = {
    environment = "DevTesting"
    project     = "Learning"
    owner       = "Patryk-Iti"
  }
}

resource "azurerm_resource_group" "rg_terraform" {
  name     = "${local.resource_group_name}"
  location = local.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${substr(local.subscription_id, 0, 7)}terra"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = local.tags
}

resource "azurerm_key_vault" "key_vault" {
  name                = local.key_vault_name
  resource_group_name = local.resource_group_name
  location            = local.location
  sku_name            = "standard"
  tenant_id           = local.tenant_id
}