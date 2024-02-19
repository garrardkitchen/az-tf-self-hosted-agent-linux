resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_ssh_public_key" "ssh_public_key" {
  name                = "${var.vm}_ssh_public_key"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  public_key          = tls_private_key.ssh.public_key_openssh
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = var.vm
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_DS2_v2"
  admin_username                  = "adminuser"
  disable_password_authentication = true
  computer_name                   = var.computer_name

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.ssh.public_key_openssh
  }

  os_disk {
    name                 = "${var.vm}osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  network_interface_ids = [azurerm_network_interface.nic.id]
 
  provisioner "file" {
    source      = "${path.module}/assets/"
    destination = "/home/adminuser"

    connection {
      host        = self.public_ip_address # azurerm_public_ip.vm-pip.ip_address
      type        = "ssh"
      user        = "adminuser"
      private_key = tls_private_key.ssh.private_key_pem
    }
  }

  user_data = base64encode(templatefile("${path.module}/scripts/user-data.sh", {
    agent_name = var.agent_name,
    pool_name  = var.pool_name,
    pat        = var.pat
  }))

  depends_on = [
    azurerm_public_ip.vm-pip,
    azurerm_network_security_group.defaultnsg,
    azurerm_network_interface.nic,
    tls_private_key.ssh
  ]
}