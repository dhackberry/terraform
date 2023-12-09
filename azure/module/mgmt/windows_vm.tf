resource "azurerm_network_interface" "nic_win" {
  count               = var.vm.windows.count
  name                = "nic-win"
  resource_group_name = var.resource_group.name
  location            = var.resource_group.location

  ip_configuration {
    name                          = "WinNicConfig"
    subnet_id                     = azurerm_subnet.sn_private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "vm_win" {
  count                 = var.vm.windows.count
  name                  = "vm-windows-${var.tags.env}"
  resource_group_name   = var.resource_group.name
  location              = var.resource_group.location
  size                  = var.vm.windows.size
  network_interface_ids = [azurerm_network_interface.nic_win[0].id]

  source_image_reference {
    publisher = var.vm.windows.image.publisher
    offer     = var.vm.windows.image.offer
    sku       = var.vm.windows.image.sku
    version   = var.vm.windows.image.version
  }

  os_disk {
    name                 = "od-${var.tags.env}-win"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  computer_name  = "${var.tags.env}-win"
  admin_username = "${var.tags.user}admin"
  admin_password = var.vm.windows.admin_password

  tags = var.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "schedule_shutdown_win" {
  count              = var.vm.windows.count
  virtual_machine_id = azurerm_windows_virtual_machine.vm_win[0].id
  location           = var.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Tokyo Standard Time"

  notification_settings {
    enabled = false
    # time_in_minutes = "60"
    # webhook_url     = "https://sample-webhook-url.example.com"
  }

  tags     = var.tags
}

# resource "azurerm_virtual_machine_extension" "custom_script_win" {
#   name                 = "InstallWsl2"
#   virtual_machine_id   = azurerm_windows_virtual_machine.vm_win.id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   protected_settings = <<SETTINGS
#     {
#       "commandToExecute": "powershell -Command \\\"Start-Process wsl --install -d ubuntu -Verb runas \\\""
#     }
#   SETTINGS
# }
