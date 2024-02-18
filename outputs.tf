output "VM_IP_ADDRESS" {
  value = azurerm_public_ip.vm-pip.ip_address
}

output "SSH_PRIVATE_KEY" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}