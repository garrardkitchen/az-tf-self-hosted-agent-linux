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