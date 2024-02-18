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
    #public_key = file("id_rsa.pub")
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

  #   provisioner "remote-exec" {
  #     inline = [
  #       "echo 'Hello, World!' > /home/adminuser/hello.txt"
  #     ]

  #     connection {
  #       type        = "ssh"
  #       user        = "adminuser"
  #       private_key = file("id_rsa")
  #       host        = self.public_ip_address
  #     }
  #   }

  #   provisioner "remote-exec" {
  #     script = "${path.module}/script.sh"

  #     connection {
  #         type        = "ssh"
  #         user        = "adminuser"
  #         private_key = file("id_rsa")
  #         host        = self.public_ip_address
  #     }
  #   }

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

# resource "null_resource" "ssh_keygen" {
#   provisioner "local-exec" {
#     #-C \"garrardkitchen@gmail.com\"
#     command = "ssh-keygen -t rsa -b 4096  -f ${path.module}/id_rsa -N ''"
#   }
# }

# resource "azurerm_linux_virtual_machine_extension" "custom_script" {
#   name                       = "${azurerm_linux_virtual_machine.vm.name}-custom-script"
#   virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
#   publisher                  = "Microsoft.Azure.Extensions"
#   type                       = "CustomScript"
#   type_handler_version       = "2.1"

#   settings = <<SETTINGS
#     {
#       "commandToExecute": "bash /path/to/your/script.sh"
#     }
#   SETTINGS
# }
