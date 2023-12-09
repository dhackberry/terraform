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
    container_name       = "tfstate"
    key                  = "terraform.tfstate.tap"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_enk_tap" {
  name     = "rg-enk-${var.tags.env}"
  location = "japaneast"
  tags     = var.tags
}

module "tap" {
  source         = "../module/aks"
  tags           = var.tags
  resource_group = azurerm_resource_group.rg_enk_tap
  network        = var.network
  aks            = var.aks
  acr            = var.acr
}
