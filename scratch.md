## Scratch

```hcl
provisioner "remote-exec" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y libunwind8 liblttng-ust0 libcurl3 libssl1.0.0 libkrb5-3 zlib1g libicu60",
    "wget https://vstsagentpackage.azureedge.net/agent/2.185.1/vsts-agent-linux-x64-2.185.1.tar.gz",
    "mkdir myagent && cd myagent",
    "tar zxvf ../vsts-agent-linux-x64-2.185.1.tar.gz",
    "./config.sh --url https://dev.azure.com/myorg --auth pat --token mytoken --pool default --agent myagent --replace",
    "sudo ./svc.sh install",
    "sudo ./svc.sh start"
 ]
}
```

```hcl
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

```