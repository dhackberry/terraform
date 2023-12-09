terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
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

resource "azurerm_container_registry_task" "acrt_build_codeserver" {
  name                  = "buil-code-server-image"
  container_registry_id = azurerm_container_registry.acr_enk.id
  platform {
    os = "Linux"
  }
  docker_step {
    dockerfile_path      = "Dockerfile"
    context_path         = "https://github.com/dhackberry/code-server.git#master:."
    context_access_token = var.github_pat
    image_names          = ["code-server:{{.Run.ID}}"]
  }
  source_trigger {
    name           = "build_trigger"
    events         = ["commit", "pullrequest"]
    repository_url = "https://github.com/dhackberry/code-server.git#master"
    source_type    = "Github"
    authentication {
      token      = var.github_pat
      token_type = "PAT"
    }
    branch  = "master"
    enabled = true
  }
}
