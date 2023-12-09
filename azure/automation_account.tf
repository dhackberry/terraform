# resource "azurerm_automation_account" "aa_vm" {
#   name                = "aa-enk-vm"
#   location            = azurerm_resource_group.rg_enk_dev.location
#   resource_group_name = azurerm_resource_group.rg_enk_dev.name

#   sku_name = "Basic"
# }

# resource "azurerm_automation_runbook" "ar_vm_start" {
#   name                    = "ar-vm-start"
#   location                = azurerm_resource_group.rg_enk_dev.location
#   resource_group_name     = azurerm_resource_group.rg_enk_dev.name
#   automation_account_name = azurerm_automation_account.aa_vm.name
#   log_verbose             = "true"
#   log_progress            = "true"
#   description             = "This Run Book is a test"
#   runbook_type            = "Graph"
#   content                 = data.local_file.demo_ps1.content
#   publish_content_link {
#     uri = "https://gallery.technet.microsoft.com/scriptcenter/The-Hello-World-of-Windows-81b69574/file/111354/1/Write-HelloWorld.ps1"
#   }
# }
