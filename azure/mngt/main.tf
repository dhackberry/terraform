terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "satfstateenk"
    container_name       = "tfstatemngt"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_enk_mgmt" {
  name     = "rg-enk-${var.tags.env}"
  location = "japaneast"
  tags     = var.tags
}

module "mngt" {
  source         = "../module/mgmt"
  tags           = var.tags
  resource_group = azurerm_resource_group.rg_enk_mgmt
  vnet           = var.vnet
  bastion        = var.bastion
  vm             = var.vm
}
