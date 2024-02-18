data "azurerm_storage_account" "sa" {
  name                = var.sa
  resource_group_name = data.azurerm_resource_group.rg.name
}