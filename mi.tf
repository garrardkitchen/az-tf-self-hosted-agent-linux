# not used
data "azurerm_client_config" "current" {
}

data "azurerm_subscription" "primary" {
}

data "azurerm_role_definition" "builtin_contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "builtin_blob_contributor" {
  name = "Storage Blob Data Contributor"
}

# RBAC: Contributor for sami @ VM
resource "azurerm_role_assignment" "mi_vm" {
  scope              = azurerm_linux_virtual_machine.vm.id
  principal_id       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.builtin_contributor.id
}

# RBAC: VM Contributor for VM sami @ sub
resource "azurerm_role_assignment" "mi_vm_sami" {
  scope              = data.azurerm_subscription.primary.id
  principal_id       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.builtin_contributor.id
}

# RBAC: Blob Contributer for VM sami @ SA
resource "azurerm_role_assignment" "mi_vm_sa" {
  scope              = data.azurerm_storage_account.sa.id
  principal_id       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
  role_definition_id = data.azurerm_role_definition.builtin_blob_contributor.id
}