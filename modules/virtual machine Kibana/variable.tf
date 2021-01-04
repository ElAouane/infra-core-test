data "azurerm_client_config" "current"{}

variable "location" {}

variable "resource-group" {}
variable "vm-size" {
  description = "virtual machine size"
  default = "Standard_A1_V2"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "subnet-name" {}
variable "virtual-network-name"{}
variable "internal-facing-name" {}


variable "kibana-connection-username" {}
variable "kibana-connection-password" {}