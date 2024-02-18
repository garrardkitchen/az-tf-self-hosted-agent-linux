#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Terraform
# -----------------------------------------------------------------------------

echo "Installing Terraform"
sudo snap install terraform --classic
terraform -v

# -----------------------------------------------------------------------------
# AZ CLI
# -----------------------------------------------------------------------------

# sudo apt-get install azure-cli
echo "Installing AZ CLI"
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# -----------------------------------------------------------------------------
# ADO
# -----------------------------------------------------------------------------

echo "Installing ADO agent"

sudo useradd -m adouser
sudo apt-get update
sudo mkdir usr/local/agent_work

cd /home/adminuser

mkdir myagent 
sudo chown -R adouser myagent
sudo chmod -R 777 myagent

cd myagent

curl -sLO https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz

tar zxvf vsts-agent-linux-x64-3.234.0.tar.gz

sudo chmod -R 777 .
sudo chown adouser config.sh

echo "Run script to install ado agent"

sudo runuser -l adminuser -c '/home/adminuser/myagent/config.sh --unattended  --url https://dev.azure.com/garrardkitchen --auth pat --token ${pat} --pool ${pool_name} --agent "${agent_name}$HOSTNAME" --work usr/local/agent_work --acceptTeeEula'

echo "Installing ado agent as a service"

sudo ./svc.sh install 
sudo ./svc.sh start
sudo ./svc.sh status

echo 'Log in using the sami identity, purerly for confirmation in logs to provde mi is working as designed'

az login --identity

# cd /home/adminuser
# sudo chown adouser ./run_server.sh 
# sudo chmod +x ./run_server.sh 
# ./run_server.sh 
