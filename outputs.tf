output "VM_IP_ADDRESS" {  
  description = "The IP of the self hosted agent"
  value = azurerm_public_ip.vm-pip.ip_address
}

output "SSH_PRIVATE_KEY" {
  description = "The private key of the self hosted agent to be used for diagnostics"
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}