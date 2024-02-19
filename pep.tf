resource "azurerm_private_endpoint" "pe" {
  name                = "ado-pe"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id
  private_service_connection {
    name                           = "blob-psc"
    private_connection_resource_id = data.azurerm_storage_account.sa.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_dns_zone" "pdns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Link the private DNS zone to the virtual network
resource "azurerm_private_dns_zone_virtual_network_link" "pdns_link" {
  name                  = "ado-pdns-link"
  resource_group_name   = data.azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.pdns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

# Create a private DNS A record for the blob service
resource "azurerm_private_dns_a_record" "pdns_a" {
  name                = data.azurerm_storage_account.sa.name
  zone_name           = azurerm_private_dns_zone.pdns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.pe.private_service_connection[0].private_ip_address]
}