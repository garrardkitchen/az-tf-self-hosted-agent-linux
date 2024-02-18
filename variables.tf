variable "rg" {
  type = string
}

variable "vnet" {
  type = string
}

variable "subnet" {
  type = string
}

variable "vm" {
  type = string
}

variable "computer_name" {
  type    = string
  default = "garrard-tf-vm"
}

variable "sa" {
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
  description = "The name of the agent"
  type        = string
  default     = "agent-"
}
variable "pool_name" {
  description = "The name of the pool"
  type        = string
  default     = "tf-pool"
}

variable "pat" {
  description = "The PAT"
  type        = string
}