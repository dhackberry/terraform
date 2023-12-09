resource "azurerm_virtual_network" "vn_aks" {
    name                = "vn-${var.tags.env}"
    address_space       = var.network.vnet.address_space
    location            = "japaneast"
    resource_group_name = var.resource_group.name
    tags = var.tags
}

resource "azurerm_subnet" "sn_aks" {
    name                 = "sn-aks-${var.tags.env}"
    resource_group_name  = var.resource_group.name
    virtual_network_name = azurerm_virtual_network.vn_aks.name
    address_prefixes     = [var.network.subnet.sn_aks_cidr]
    service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage", "Microsoft.KeyVault"]
}

# Azure kobetsubu LB subnet
resource "azurerm_subnet" "sn_lb" {
    name                 = "sn-lb-${var.tags.env}"
    resource_group_name  = var.resource_group.name
    virtual_network_name = azurerm_virtual_network.vn_aks.name
    address_prefixes     = [var.network.subnet.sn_lb_cidr]
}
