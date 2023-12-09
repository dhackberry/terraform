terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.7.0"
    }
  }
}

provider "azurerm" {
  features {}
  }

resource "azurerm_resource_group" "rg_bastion" {
  name     = "rg-bas"
  location = "japaneast"
}

resource "azurerm_virtual_network" "vn_bastion" {
  name                = "vn-bas"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name
  address_space       = ["10.3.0.0/16"]
  dns_servers         = ["10.3.0.4", "10.3.0.5"]
}

resource "azurerm_subnet" "sn_bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg_bastion.name
  virtual_network_name = azurerm_virtual_network.vn_bastion.name
  address_prefixes     = ["10.3.1.0/24"]
}

resource "azurerm_subnet" "sn_private" {
  name                 = "sn-private"
  resource_group_name  = azurerm_resource_group.rg_bastion.name
  virtual_network_name = azurerm_virtual_network.vn_bastion.name
  address_prefixes     = ["10.3.2.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_bastion" {
  subnet_id                 = azurerm_subnet.sn_bastion.id
  network_security_group_id = azurerm_network_security_group.nsg_bastion.id
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_private" {
  subnet_id                 = azurerm_subnet.sn_private.id
  network_security_group_id = azurerm_network_security_group.nsg_private.id
}

resource "azurerm_public_ip" "pip_bastion" {
  name                = "pip-bas"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "host_bastion" {
  name                = "host-bas"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name
  sku                 = "Standard"
  tunneling_enabled   = true

  ip_configuration {
    name                 = "vm_ip_configuration"
    subnet_id            = azurerm_subnet.sn_bastion.id
    public_ip_address_id = azurerm_public_ip.pip_bastion.id
  }
}

resource "azurerm_network_security_group" "nsg_bastion" {
  name                = "nsg-bastion"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

  security_rule {
    name                       = "AllowGatewayInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
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
    protocol                   = "Tcp"
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
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges     = ["3389","22"]
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  }

 security_rule {
    name                       = "AllowAzureCloudOutBound"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  }
}

resource "azurerm_network_security_group" "nsg_private" {
  name                = "nsg-private"
  location            = azurerm_resource_group.rg_bastion.location
  resource_group_name = azurerm_resource_group.rg_bastion.name

    security_rule {
    name                       = "AllowBastionVnetInBound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_ranges     = ["3389","22"]
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
    destination_port_ranges     = ["3389","22"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic_testvm" {
    name                      = "nic-testvm"
    location                  = azurerm_resource_group.rg_bastion.location
    resource_group_name       = azurerm_resource_group.rg_bastion.name

    ip_configuration {
        name                          = "NicConfiguration"
        subnet_id                     = azurerm_subnet.sn_private.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_linux_virtual_machine" "vm_test" {
    name                  = "vm-test"
    location              = azurerm_resource_group.rg_bastion.location
    resource_group_name   = azurerm_resource_group.rg_bastion.name
    network_interface_ids = [azurerm_network_interface.nic_testvm.id]
    size                  = "Standard_B2s"

    os_disk {
        name              = "testVmOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-focal"
        sku       = "20_04-lts-gen2"
        version   = "latest"
    }

    computer_name  = "mgmt"
    admin_username = "basuser"
    admin_password = "basP@ss"
    disable_password_authentication = false

    admin_ssh_key {
        username       = "basuser"
        public_key     = tls_private_key.ssh_bastion.public_key_openssh
    }
}

resource "tls_private_key" "ssh_bastion" {
  algorithm = "RSA"
  rsa_bits = 4096
}

output "tls_private_key" {
  value = tls_private_key.ssh_bastion.private_key_pem
  sensitive = true
}

resource "local_file" "private_key_pem" {
  filename = "./bas_ssh_key.pem"
  content  = tls_private_key.ssh_bastion.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ./bas_ssh_key.pem"
  }
}
