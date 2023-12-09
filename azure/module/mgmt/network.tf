
resource "azurerm_virtual_network" "vn_mgmt" {
  name                = "vn-${var.tags.env}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  address_space       = var.vnet.address_space
  dns_servers         = var.vnet.dns_servers
  tags                = var.tags
}

resource "azurerm_subnet" "sn_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vn_mgmt.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "sn_private" {
  name                 = "sn-private"
  resource_group_name  = var.resource_group.name
  virtual_network_name = azurerm_virtual_network.vn_mgmt.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_bastion" {
  subnet_id                 = azurerm_subnet.sn_bastion.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_private" {
  subnet_id                 = azurerm_subnet.sn_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}
