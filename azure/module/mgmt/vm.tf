resource "azurerm_network_interface" "nic_mgmt" {
  name                = "nic-${var.tags.env}"
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name

  ip_configuration {
    name                          = "NicConfiguration"
    subnet_id                     = azurerm_subnet.sn_private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm_mgmt" {
  name                  = "vm-${var.tags.env}"
  location              = var.resource_group.location
  resource_group_name   = var.resource_group.name
  network_interface_ids = [azurerm_network_interface.nic_mgmt.id]
  size                  = var.vm.linux.size

  os_disk {
    name                 = "od-${var.tags.env}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm.linux.image.publisher
    offer     = var.vm.linux.image.offer
    sku       = var.vm.linux.image.sku
    version   = var.vm.linux.image.version
  }

  computer_name                   = var.tags.env
  admin_username                  = "${var.tags.user}user"
  disable_password_authentication = true
  #custom_data = filebase64("../module/mgmt/cloud-init.sh")
  #custom_data    = base64encode(data.template_file.linux-vm-cloud-init.rendered)
  #custom_data    = base64encode(file("../module/mgmt/cloud-init.sh"))

  admin_ssh_key {
    username   = "${var.tags.user}user"
    public_key = tls_private_key.ssh_mgmt.public_key_openssh
  }

  tags = var.tags
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "schedule_shutdown_mgmt" {
  virtual_machine_id = azurerm_linux_virtual_machine.vm_mgmt.id
  location           = var.resource_group.location
  enabled            = true

  daily_recurrence_time = "1800"
  timezone              = "Tokyo Standard Time"

  notification_settings {
    enabled = false
    # time_in_minutes = "60"
    # webhook_url     = "https://sample-webhook-url.example.com"
  }

  tags = var.tags
}

resource "tls_private_key" "ssh_mgmt" {
  algorithm = "RSA"
  rsa_bits  = 4096

}
output "tls_private_key" {
  value     = tls_private_key.ssh_mgmt.private_key_pem
  sensitive = true
}

resource "local_file" "private_key_pem" {
  filename = "./bas_ssh_key.pem"
  content  = tls_private_key.ssh_mgmt.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ./bas_ssh_key.pem"
  }

}
