resource "azurerm_container_registry" "acr-i4-tap" {
  name                     = "acrenk${var.tags.env}"
  resource_group_name      = var.resource_group.name
  location                 = var.resource_group.location
  sku                      = var.acr.sku
  admin_enabled            = true
}
