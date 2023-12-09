terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.84.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_cmn" {
  location = var.resource_group_location
  name     = "rg-cmn"
}

resource "azurerm_container_registry" "acr_enk" {
  name                = "acrenk"
  resource_group_name = azurerm_resource_group.rg_cmn.name
  location            = azurerm_resource_group.rg_cmn.location
  sku                 = "Standard"
  admin_enabled       = false
}
