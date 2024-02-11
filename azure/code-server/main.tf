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

resource "azurerm_resource_group" "rg_code_server" {
  location = "japaneast"
  name     = "rg-code-server"
}

# Azure Container Appsを使う場合
resource "azurerm_container_app_environment" "acae_code_server" {
  name                = "Codeserver-Environment"
  location            = azurerm_resource_group.rg_code_server.location
  resource_group_name = azurerm_resource_group.rg_code_server.name
}

resource "azurerm_container_app" "aca_code_server" {
  name                         = "aca-code-server"
  container_app_environment_id = azurerm_container_app_environment.acae_code_server.id
  resource_group_name          = azurerm_resource_group.rg_code_server.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.containerapp.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr_cmn.login_server
    identity = azurerm_user_assigned_identity.containerapp.id
  }

  template {
    container {
      name   = "code-server"
      image  = "${data.azurerm_container_registry.acr_cmn.login_server}/code-server-dummy-2:latest"
      cpu    = 2
      memory = "4Gi"

      env {
        name  = "PORT"
        value = "80"
      }
      env {
        name  = "PASSWORD"
        value = "password"
      }

      readiness_probe {
        transport = "HTTP"
        port      = 80
      }

      liveness_probe {
        transport = "HTTP"
        port      = 80
      }

      startup_probe {
        transport = "HTTP"
        port      = 80
      }

    }
  }

  ingress {
    target_port      = 80
    external_enabled = true
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
    # custom_domain {
    #   certificate_id           = "acrenk.azurecr.io"
    #   certificate_binding_type = "SniEnabled"
    #   name                     = "tap.hackberry.me"
    # }
  }
}

resource "azurerm_user_assigned_identity" "containerapp" {
  location            = azurerm_resource_group.rg_code_server.location
  name                = "containerappmi"
  resource_group_name = azurerm_resource_group.rg_code_server.name
}

resource "azurerm_role_assignment" "containerapp" {
  scope                = data.azurerm_container_registry.acr_cmn.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.containerapp.principal_id
  depends_on = [
    azurerm_user_assigned_identity.containerapp
  ]
}

data "azurerm_container_registry" "acr_cmn" {
  name                = "acrenk"
  resource_group_name = "rg-cmn"
}

# data "azurerm_resource_group" "rg_cmn" {
#   name = "rg-cmn"
# }


# output "fqdn" {
#   value = "https://${azurerm_container_app.example.latest_revision_fqdn}"
# }
