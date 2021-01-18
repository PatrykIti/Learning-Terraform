/*
    Preparing backend to save state remotly on Azure Storage Container.
*/


provider "azurerm" {
  features{}
}

data "azurerm_subscription" "current" {}

locals {
  #Information about subscription
  subscription_id = data.azurerm_subscription.current.subscription_id
  tenant_id       = data.azurerm_subscription.current.tenant_id

  #Variables of Remote State module
  resource_prefix_remote_state     = "terra"
  location                         = "westus2"
  key_vault_name_remote_state      = "TerraVaultUdemy"
  resource_group_name_remote_state = "terra-rg"

  #Common Variables
  tags = {
    environment = "DevTesting"
    project     = "Learning"
    owner       = "Patryk-Iti"
  }
}

module "backend_remote_state" {
  source = "./remote state"

  subscription_id = local.subscription_id
  tenant_id       = local.tenant_id

  resource_group_name_remote_state = local.resource_group_name_remote_state
  resource_prefix_remote_state     = local.resource_prefix_remote_state
  key_vault_name_remote_state      = local.key_vault_name_remote_state
  location                         = local.location
  tags = local.tags
}

