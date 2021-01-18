resource "azurerm_resource_group" "rg_terraform" {
  name     = var.resource_group_name_remote_state
  location = var.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "st${substr(var.subscription_id, 0, 7)}${var.resource_prefix_remote_state}"
  location                 = var.location
  resource_group_name      = var.resource_group_name_remote_state
  account_tier             = "Standard"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.rg_terraform]
  tags                     = var.tags
}

resource "azurerm_storage_container" "terraform_backend_storage" {
  name                  = var.resource_prefix_remote_state
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.storage_account]
}

resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name_remote_state
  resource_group_name = var.resource_group_name_remote_state
  location            = var.location
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  soft_delete_enabled = false
  depends_on          = [azurerm_resource_group.rg_terraform]
}

resource "azurerm_key_vault_access_policy" "key_vault_access_policy" {
  key_vault_id = azurerm_key_vault.key_vault.id
  tenant_id    = var.tenant_id
  object_id    = "d65e360c-316d-4d89-b34d-1c7b2321574f"
  depends_on   = [azurerm_key_vault.key_vault]

  secret_permissions = [
    "backup", "delete", "get", "list", "purge", "recover", "restore", "set"
  ]
}

resource "azurerm_key_vault_secret" "admin_password" {
  name         = "admin-password"
  value        = "Pa$$w0rd"
  key_vault_id = azurerm_key_vault.key_vault.id
  depends_on   = [azurerm_key_vault_access_policy.key_vault_access_policy]
}
