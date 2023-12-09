
resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bas-${var.tags.env}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  allocation_method   = var.bastion.pip.allocation_method
  sku                 = var.bastion.pip.sku
  tags                = var.tags
}

resource "azurerm_bastion_host" "host_bastion" {
  name                = "bas-${var.tags.env}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  sku                 = var.bastion.host.sku
  tunneling_enabled   = var.bastion.host.tunneling_enabled

  ip_configuration {
    name                 = "vm_ip_configuration-${var.tags.env}"
    subnet_id            = azurerm_subnet.sn_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }
  tags = var.tags
}


