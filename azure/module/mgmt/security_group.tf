resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-bastion"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags                = var.tags

  security_rule {
    name                       = "AllowGatewayInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowInternetInBound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowPrivateVnetOutBound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowAzureCloudOutBound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }

  #   security_rule {
  #     name                       = "AllowBastionHostCommunicationInbound"
  #     priority                   = 1005
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_ranges     = ["8080","5701"]
  #     source_address_prefix      = "VirtualNetwork"
  #     destination_address_prefix = "VirtualNetwork"
  #   }
  #   security_rule {
  #     name                       = "AllowBastionHostCommunicationOutbound"
  #     priority                   = 1005
  #     direction                  = "Outbound"
  #     access                     = "Allow"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_ranges     = ["8080","5701"]
  #     source_address_prefix      = "VirtualNetwork"
  #     destination_address_prefix = "VirtualNetwork"
  #   }
  #   security_rule {
  #     name                       = "AllowGetSessionInfomation"
  #     priority                   = 1006
  #     direction                  = "Outbound"
  #     access                     = "Allow"
  #     protocol                   = "*"
  #     source_port_range          = "*"
  #     destination_port_range     = "80"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "Internet"
  #   }
}


resource "azurerm_network_security_group" "nsg_private" {
  name                = "nsg-private"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  tags     = var.tags

  security_rule {
    name                       = "AllowBastionVnetInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowBastionVnetOutBound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}
