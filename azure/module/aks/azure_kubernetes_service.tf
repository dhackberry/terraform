resource "azuread_application" "app-aks" {
  display_name  = "appaks${var.tags.env}"
}

resource "random_password" "rpass-aks" {
  length    = 32
  special   = true # Include special characters
  override_special = "!@" 
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.tags.env}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  dns_prefix          = "aks-${var.tags.env}"
  kubernetes_version  = var.aks.kubernetes_version
  private_cluster_enabled = var.aks.private_cluster_enabled
  sku_tier            = var.aks.sku_tier
  tags = var.tags

  default_node_pool {
    name                  = "aksshsg${var.tags.env}" 
    vm_size               = var.aks.default_node_pool.vm_size
    enable_auto_scaling   = true
    min_count             = var.aks.default_node_pool.min_count
    max_count             = var.aks.default_node_pool.max_count
    enable_node_public_ip = false 
    orchestrator_version  = var.aks.default_node_pool.orchestrator_version
    vnet_subnet_id        = azurerm_subnet.sn_aks.id
    type = "VirtualMachineScaleSets" 
  }

  auto_scaler_profile {
    balance_similar_node_groups      = false # default
    max_graceful_termination_sec     = 600 # default
    new_pod_scale_up_delay           = "10s" # default
    scale_down_delay_after_add       = "10m" # default
    scale_down_delay_after_delete    = "10s" # default
    scale_down_delay_after_failure   = "3m"  # default
    scan_interval                    = "10s" # default
    scale_down_unneeded              = "10m" # default
    scale_down_unready               = "20m" # default
    scale_down_utilization_threshold = var.aks.auto_scaler_profile.scale_down_utilization_threshold
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "azure"
    load_balancer_sku  = var.aks.network_profile.load_balancer_sku
  }

  # managed identity
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "aks-sh-ug" {
  name                  = "aksshug${var.tags.env}" 
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.aks.user_node_pool.vm_size
  enable_auto_scaling   = true
  min_count             = var.aks.user_node_pool.min_count
  max_count             = var.aks.user_node_pool.max_count
  vnet_subnet_id        = azurerm_subnet.sn_aks.id
  tags = var.tags
}
