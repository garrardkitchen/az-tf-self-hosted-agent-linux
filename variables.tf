variable "rg" {
  description = "The Resource Group where these resouces will be created"
  type = string
}

variable "vnet" {
  description = "The name of the VNET that (a) will be created and 9b) where the self hosted agent will exist"
  type = string
}

variable "subnet" {
  description = "The name of the subnet where the self hosted agent will exist"
  type = string
}

variable "vm" {
  description = "The name of the self hosted agent VM"
  type = string
}

variable "computer_name" {
  description = "The hostname of the self hosted agent"
  type    = string
  default = "garrard-tf-vm"
}

variable "sa" {
  description = "The name of the Storage Account where the remote state will persist"
  type = string
}

variable "allowed_ssh_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the Azure VM will allow SSH connections"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allowed_inbound_cidr_blocks" {
  description = "A list of CIDR-formatted IP address ranges from which the Azure VM will allow connections"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "allow_outbound_cidr_blocks" {
  description = "Allow outbound traffic to these CIDR blocks"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
variable "agent_name" {
  description = "The name of the ADO agent"
  type        = string
  default     = "agent-"
}
variable "pool_name" {
  description = "The name of the ADO pool where the ADO agent will live"
  type        = string
  default     = "tf-pool"
}

variable "pat" {
  description = "The PAT"
  type        = string
}