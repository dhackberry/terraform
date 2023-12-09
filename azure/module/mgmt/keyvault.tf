# data "azurerm_client_config" "current" {}

# resource "azurerm_key_vault" "kv_enk_dev_bastion" {
#   name                = "kv-enk-bastion"
#   location            = azurerm_resource_group.rg_enk_dev.location
#   resource_group_name = azurerm_resource_group.rg_enk_dev.name
#   tenant_id           = data.azurerm_client_config.current.tenant_id

#   sku_name = "standard"

#   access_policy {
#     tenant_id = data.azurerm_client_config.current.tenant_id
#     object_id = data.azurerm_client_config.current.object_id

#     key_permissions = [
#       "create",
#       "get",
#     ]

#     secret_permissions = [
#       "list",
#       "set",
#       "get",
#       "delete",
#       "purge",
#       "recover"
#     ]
#   }
# }

# resource "azurerm_key_vault_secret" "kv_secret_bastion" {
#   name         = "mgmt-ssh-key"
#   value        = tls_private_key.mgmt_ssh.private_key_pem
#   key_vault_id = azurerm_key_vault.kv_enk_dev_bastion.id
# }
